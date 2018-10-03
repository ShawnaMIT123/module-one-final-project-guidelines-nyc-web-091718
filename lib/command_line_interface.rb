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
  puts "1. Log a meal"
  puts "2. View my meal"
  puts "3. Analyze Nutrition"
  puts "4. Update/Review Goals"
  action_number = gets.chomp.to_i
  case action_number
    when 1
      log_a_meal
    when 2
      view_meals
    when 3
      analyze_nutrition
    when 4
      update_goals
    else
      puts "Please enter a number 1-4."
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
end

def view_meals
  userinstance = $user_profile
  #array = UserMeal.find(:all, :conditions => [ "user_id = ?", userinstance])
  usermealinstances = UserMeal.where(user_id: userinstance, date: date)

  dates = usermealinstances.map{|usermealinstance| usermealinstance.date}

  dates.each do |date|
  puts "#{date}"
  mealsbydate =   usermealinstances.find_by(date: date).each do |instance|
      mealinstance = Meal.find_by(instance.meal_id)
        puts mealinstance
    end
  end
end
#
# def analyze_nutrition
#
# end
#
# def update_goals
#
# end
