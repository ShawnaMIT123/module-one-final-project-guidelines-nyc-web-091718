class UserMeal < ActiveRecord::Base
  belongs_to :meal
  belongs_to :user
end
