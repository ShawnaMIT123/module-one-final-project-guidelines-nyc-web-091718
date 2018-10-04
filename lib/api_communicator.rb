require 'rest-client'
require 'json'
require 'pry'
require 'unirest'
require 'dotenv'


def ask_api(recipe_name)
  recipe_name_plus = recipe_name.gsub(" ", "+")
  response = Unirest.get "https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/recipes/guessNutrition?title=#{recipe_name_plus}",
 headers:{
   "X-Mashape-Key" => ENV['API_KEY'],
   "Accept" => "application/json"}

 # binding.pry
 response.body
end
