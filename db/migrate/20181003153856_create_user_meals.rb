class CreateUserMeals < ActiveRecord::Migration[5.0]
  def change
    create_table :user_meals do |t|
      t.date :date
      t.integer :meal_id
      t.integer :user_id
    end
  end
end
