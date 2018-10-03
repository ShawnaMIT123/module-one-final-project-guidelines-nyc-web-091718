require 'rest-client'
require 'json'
require 'pry'
require 'unirest'


def ask_api(recipe_name)
  recipe_name_plus = recipe_name.gsub(" ", "+")
  response = Unirest.get "https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/recipes/guessNutrition?title=#{recipe_name_plus}",
 headers:{
   "X-Mashape-Key" => "",
   "Accept" => "application/json"}

 # binding.pry
 response.body
end
