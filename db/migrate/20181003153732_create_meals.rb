class CreateMeals < ActiveRecord::Migration[5.0]
  def change
    create_table :meals do |t|
      t.string :name
      t.integer :calorie
      t.integer :fat
      t.integer :carbs
      t.integer :protein
    end
  end
end
