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
  puts "What would you like to do? Input a number to indicate choice."
  puts "1. Log A Meal"
  puts "2. View My Meal Log"
  puts "3. Search Nutrition Info"
  puts "4. Update/Review Goals"
  puts "5. Analyze Nutrition"
  puts "6. Exit program"
  action_number = gets.chomp.to_i
  userinstance = $user_profile
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
      analyze_nutrition
    when 6
      puts "Goodbye #{userinstance.name}!"
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
  userinstance = $user_profile

   if Meal.find_by(name: meal) != nil
     mealinstance = Meal.find_by(name: meal)
     UserMeal.create(date: date, meal_id: mealinstance.id, user_id: userinstance.id)
  else
    response_hash = ask_api(meal)
    cal = response_hash["calories"]["value"]
    f = response_hash["fat"]["value"]
    c = response_hash["carbs"]["value"]
    pr = response_hash["protein"]["value"]
    m = Meal.create(name: meal, calorie: cal, fat: f, carbs: c, protein: pr)
    # do we need to store unit?
    UserMeal.create(date: date, meal_id: m.id, user_id: userinstance.id)
  end
user_action
end

def view_meals
  userinstance = $user_profile
  usermealinstances = UserMeal.where(user_id: userinstance)
  dates = usermealinstances.map{|usermealinstance| usermealinstance.date}.sort.uniq
  dates.each do |date|
  puts "#{date}"
  usermealsbydateinstances = UserMeal.where(user_id: userinstance, date: date)
   usermealsbydateinstances.each do |instance|
       mealname = Meal.find_by(id: instance.meal_id)
        puts "#{mealname.name} cals: #{mealname.calorie}, fat: #{mealname.fat}, carbs: #{mealname.carbs}, protein: #{mealname.protein}"
    end
  end
user_action
end

def search_nutrition_info
  puts "Whats the name of the meal you would like to get nutrition information for?"
  meal = gets.chomp
  userinstance = $user_profile

   if Meal.find_by(name: meal) != nil
     mealinstance = Meal.find_by(name: meal)
     puts "#{mealinstance.name} cals: #{mealinstance.calorie}, fat: #{mealinstance.fat}, carbs: #{mealinstance.carbs}, protein: #{mealinstance.protein}"
  else
    response_hash = ask_api(meal)
    cal = response_hash["calories"]["value"]
    f = response_hash["fat"]["value"]
    c = response_hash["carbs"]["value"]
    pr = response_hash["protein"]["value"]
    m = Meal.create(name: meal, calorie: cal, fat: f, carbs: c, protein: pr)
    # do we need to store unit?
    puts "#{m.name} cals: #{m.calorie}, fat: #{m.fat}, carbs: #{m.carbs}, protein: #{m.protein}"
  end
user_action
end


#
# def analyze_nutrition
#   userinstance = $user_profile
#   puts "Would you like to look at your nutrition for today or last 7 days? (T/7)"
#   timebreakdown = gets.chomp
#   if timebreakdown == 'T'
#     puts
#     usermealinstances = UserMeal.where(user_id: userinstance, date: date)
#   elsif timebreakdown ==
#   usermealinstances = UserMeal.where(user_id: userinstance, date: date)
#
# end
def show_goals
  userinstance = $user_profile
  puts "CURRENT DAILY CALORIE GOAL: #{userinstance.calorie_goal}"
  puts "CURRENT DAILY FAT GOAL: #{userinstance.fat_goal}"
  puts "CURRENT DAILY CARBS GOAL: #{userinstance.carbs_goal}"
  puts "CURRENT DAILY PROTEIN GOAL: #{userinstance.protein_goal}"
end

def update_goals
show_goals
puts "What goal would you like to update? Input a number to indicate choice."
puts "1. Calorie"
puts "2. Fat"
puts "3. Carbs"
puts "4. Protein"
puts "5. Keep these goals"

goal = gets.chomp.to_i
  if goal == 5

  else
  puts "Enter new daily goal"
  goal_amount = gets.chomp.to_i
  userinstance = $user_profile
      case goal
        when 1
          userinstance.calorie_goal = goal_amount
        when 2
          userinstance.fat_goal = goal_amount
        when 3
          userinstance.carbs_goal = goal_amount
        when 4
          userinstance.protein_goal = goal_amount
      end
      userinstance.save
  puts "Congratulations! Your goals are updated!"
  show_goals
  end
user_action
end
