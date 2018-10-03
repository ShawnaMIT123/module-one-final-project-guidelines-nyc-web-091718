CLI Nutrition Log

Minimum
As a user, I want to be able to search for my meal and receive nutrition info.
As a user, I want to be able to log my meals by date.
As a user, I want to be able to "log in" using my name.
As a user, I want to be able to set a daily calorie goal.
As a user, I want to be able to review my meal log.
As a user, I want to be able to check on my nutritional stats - actual vs goal.

Secondary goals
As a user, I want to be able to clear my log.
As a user, I want to be able to log my meals by date and B/L/D.
As a user, I want to be able to see my top 3 logged meals.
As a user, I want to be able to see my high calorie meals.
As a user, I want to be able to delete one item from my log.


run program
- Welcome to Nutrition Log CLI!
  1. New User
  2. Returning User

- New User
  # Gets input of name & goals
  # Goals - Calories required, fat/carbs/protein optional

- Returning User
  # Gets & looks up name

- Puts Main Menu, Gets response
  1. Log a meal
  2. View my meal
  3. Analyze Nutrition
  4. Update/Review Goals

- 1. Log a Meal
  # Search by meal name
    #first search meal table, then API
  # Gets meal date
  # Saves meal

- 2. View my meal
  - 1. Daily
  - 2. Weekly

- 3. Analyze Nutrition
  - 1. Daily
  - 2. Weekly

- 4. Update/Review Goals
