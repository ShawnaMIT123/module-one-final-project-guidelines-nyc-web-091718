class CreateUsers < ActiveRecord::Migration[5.0]
  def change
     create_table :users do |t|
       t.string :name
       t.integer :calorie_goal
       t.integer :fat_goal
       t.integer :carbs_goal
       t.integer :protein_goal
     end
  end
end
