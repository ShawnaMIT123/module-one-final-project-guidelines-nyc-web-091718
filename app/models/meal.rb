class Meal < ActiveRecord::Base
  has_many :user_meals
  has_many :meals, through: :user_meals
end
