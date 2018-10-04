require 'pry'
require_relative '../config/environment'
require_relative '../app/models/meal.rb'
require_relative '../app/models/user.rb'
require_relative '../app/models/user_meal.rb'
require_relative './api_communicator.rb'

def welcome
puts "Welcome to Nutrition Log CLI!"
end

def get_login
  puts "Do you have an existing account. (Y/N)"
  response = gets.chomp
  if response.upcase == "N"
    puts "Enter your fullname."
    name = gets.chomp
    puts "What's your daily calorie goal?"
    goal = gets.chomp
    User.create(name: name, calorie_goal: goal)
  elsif response.upcase == "Y"
    puts "Enter your fullname."
    name = gets.chomp
   else
     puts "Please try again and enter Y or N"
     get_login
  end
  $user_profile = User.find_by(name:name)
  puts "Welcome #{name}!"
end


def user_action
  puts "\nWhat would you like to do? Input a number to indicate choice."
  puts "   1. Log A Meal"
  puts "   2. View My Meal Log"
  puts "   3. Search Nutrition Info"
  puts "   4. Update/Review Goals"
  puts "   5. Analytics"
  puts "   6. Exit program"
  action_number = gets.chomp.to_i
  case action_number
    when 1
      log_a_meal
    when 2
      view_meals
    when 3
      search_nutrition_info
    when 4
      update_goals
    when 5
      analytics_menu
    when 6
      puts "Goodbye, #{$user_profile.name}!"
    else
      puts "Please enter a number 1-6."
      user_action
  end
end

def log_a_meal
  puts "Whats the name of the meal you would like to log?"
    meal = gets.chomp
  puts "Great! What date would you like to log your meal for? (YYYY-MM-DD)"
    date = gets.chomp

   if Meal.find_by(name: meal) != nil
     mealinstance = Meal.find_by(name: meal)
     UserMeal.create(date: date, meal_id: mealinstance.id, user_id: $user_profile.id)
  else
    response_hash = ask_api(meal)
    cal = response_hash["calories"]["value"]
    f = response_hash["fat"]["value"]
    c = response_hash["carbs"]["value"]
    pr = response_hash["protein"]["value"]
    m = Meal.create(name: meal, calorie: cal, fat: f, carbs: c, protein: pr)
    UserMeal.create(date: date, meal_id: m.id, user_id: $user_profile.id)
  end
user_action
end

def view_meals
  usermealinstances = UserMeal.where(user_id: $user_profile)
  dates = usermealinstances.map{|usermealinstance| usermealinstance.date}.sort.uniq
  dates.each do |date|
  puts "\n#{date}\n"
  usermealsbydateinstances = UserMeal.where(user_id: $user_profile, date: date)
   usermealsbydateinstances.each do |instance|
       mealname = Meal.find_by(id: instance.meal_id)
        puts "     #{mealname.name} cals: #{mealname.calorie}, fat: #{mealname.fat}, carbs: #{mealname.carbs}, protein: #{mealname.protein}\n"
    end
  end
user_action
end

def search_nutrition_info
  puts "Whats the name of the meal you would like to get nutrition information for?"
  meal = gets.chomp

   if Meal.find_by(name: meal) != nil
     mealinstance = Meal.find_by(name: meal)
     puts "\n#{mealinstance.name} cals: #{mealinstance.calorie}, fat: #{mealinstance.fat}, carbs: #{mealinstance.carbs}, protein: #{mealinstance.protein}"
  else
    response_hash = ask_api(meal)
    cal = response_hash["calories"]["value"]
    f = response_hash["fat"]["value"]
    c = response_hash["carbs"]["value"]
    pr = response_hash["protein"]["value"]
    m = Meal.create(name: meal, calorie: cal, fat: f, carbs: c, protein: pr)
    # do we need to store unit?
    puts "\n#{m.name} cals: #{m.calorie}, fat: #{m.fat}, carbs: #{m.carbs}, protein: #{m.protein}\n"
  end
user_action
end


#
# def analyze_nutrition
#   $user_profile = $user_profile
#   puts "Would you like to look at your nutrition for today or last 7 days? (T/7)"
#   timebreakdown = gets.chomp
#   if timebreakdown == 'T'
#     puts
#     usermealinstances = UserMeal.where(user_id: $user_profile, date: date)
#   elsif timebreakdown ==
#   usermealinstances = UserMeal.where(user_id: $user_profile, date: date)
#
# end


def show_goals
  puts "\nCURRENT DAILY CALORIE GOAL: #{$user_profile.calorie_goal}"
  puts "        DAILY FAT GOAL: #{$user_profile.fat_goal}"
  puts "        DAILY CARBS GOAL: #{$user_profile.carbs_goal}"
  puts "        DAILY PROTEIN GOAL: #{$user_profile.protein_goal}"
end

def update_goals
  show_goals
  puts "\nWhat goal would you like to update? Input a number to indicate choice."
  puts "   1. Calorie"
  puts "   2. Fat"
  puts "   3. Carbs"
  puts "   4. Protein"
  puts "   5. Keep these goals"

  goal = gets.chomp.to_i
    if goal == 5
      #no update
    else
    puts "\nEnter new daily goal"
    goal_amount = gets.chomp.to_i
        case goal
          when 1
            $user_profile.calorie_goal = goal_amount
          when 2
            $user_profile.fat_goal = goal_amount
          when 3
            $user_profile.carbs_goal = goal_amount
          when 4
            $user_profile.protein_goal = goal_amount
        end
        $user_profile.save
    puts "\nCongratulations! Your goals are updated!\n"
    show_goals
    end
  user_action
end


def analytics_menu
  puts "\nWhat would you like to review?"
  puts "   1. Nutrition Goals vs. Logged Meals"
  puts "   2. View Logged Meals Over 500 calories"
  puts "   3. View Highest Calorie Meals"
  puts "   4. View Favorite Meals"
  puts "   5. Main Menu"

  action_number = gets.chomp.to_i
  if action_number == 5
    user_action
    #back to main menu
  else
    case action_number
      when 1
        goal_progress
      when 2
        calorie_dense_meals
      when 3
        highest_calorie_meals
      when 4
        favorite_meals
      else
        puts "Please enter a number 1-5."
        analytics_menu
    end
  end
end

def get_meal_hash
  meal_hash = {}
  usermealinstances = UserMeal.where(user_id: $user_profile).sort_by &:date
  i = 1

  usermealinstances.map do |instance|
    i_cal = Meal.find_by(id: instance.meal_id).calorie
    if meal_hash["#{instance.date}"] == nil
      meal_hash["#{instance.date}"] = {}
      meal_hash["#{instance.date}"][:daily_total] = i_cal
      meal_hash["#{instance.date}"][:logged] = {}
      meal_hash["#{instance.date}"][:logged]["#{i}"] = "#{Meal.find_by(id: instance.meal_id).name}, #{i_cal} calories"
      i += 1
    else
      meal_hash["#{instance.date}"][:daily_total] += i_cal
      meal_hash["#{instance.date}"][:logged]["#{i}"] = "#{Meal.find_by(id: instance.meal_id).name}, #{i_cal} calories"
      i += 1
    end
  end
  meal_hash
  # binding.pry
end


def goal_progress
  #shows calorie intake vs goal
  meal_hash = get_meal_hash
  puts "\nYour daily calorie goal is #{$user_profile.calorie_goal}."
  puts "\nHere are your daily totals:"
  meal_hash.each do |date, hash|
    calories_logged = meal_hash[date][:daily_total].to_f
    cal_goal = $user_profile.calorie_goal.to_f
    # binding.pry

    puts "\n#{date} -- Daily Total: #{calories_logged.to_i} calories."
      if calories_logged > cal_goal
        over = (((calories_logged - cal_goal)/cal_goal) * 100).round
        puts "Uh oh! You have exceeded your daily calorie goal by #{over}%."
      elsif calories_logged < cal_goal
        used = ((calories_logged/cal_goal) * 100).round
        remainder = (cal_goal - calories_logged).to_i
        puts "You have used #{used}% of your calories for the day. #{remainder} calories remaining."
      elsif calories_logged == cal_goal
        puts "Congratulations! You met your goal."
      end
    hash[:logged].each do |i, meal|
      puts "     #{meal}"
    end
  end
  user_action
end

def calorie_dense_meals
  calorie_dense = []

  usermealinstances = UserMeal.where(user_id: $user_profile).sort_by &:date
  usermealinstances.each do |instance|
    if Meal.find_by(id: instance.meal_id).calorie > 500
      calorie_dense << "#{Meal.find_by(id: instance.meal_id).name} (#{Meal.find_by(id: instance.meal_id).calorie} calories) on #{instance.date}"
    end
  end

  if calorie_dense.empty?
    puts "You have not logged any meals over 500 calories."
  else
    puts "You've logged these high calorie meals:"
    calorie_dense.each do |meal|
      puts "     #{meal}"
    end
  end
  user_action
end

def highest_calorie_meals
  #shows top 3 highest cal meals

  analytics_menu
end

def favorite_meals
  #shows most common meal logged

  analytics_menu
end


### HELPER METHODS ###
