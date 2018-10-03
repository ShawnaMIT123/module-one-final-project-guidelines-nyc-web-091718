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

  # else
  #   puts "Please enter Y or N"
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
  action_number = gets.chomp
end

def log_a_meal
  puts "Whats the name of the meal you would like to log?"
  meal = gets.chomp
  puts "Great! What date would you like to log your meal for? (YYYY-MM-DD)"
  date = gets.chomp

   if Meal.find_by(name: meal) != nil
     mealinstance = Meal.find_by(name: meal)
     userinstance = $user_profile
     UserMeal.create(date: date, meal_id: mealinstance.id, user_id: userinstance.id)
     binding.pry
  end

end
#
# def view_meals
#   puts
# end
#
# def analyze_nutrition
#
# end
#
# def update_goals
#
# end
