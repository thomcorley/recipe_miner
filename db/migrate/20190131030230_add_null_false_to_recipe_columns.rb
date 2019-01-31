class AddNullFalseToRecipeColumns < ActiveRecord::Migration[5.1]
  def change
  	change_column_null :recipes, :title, false
  	change_column_null :recipes, :image_url, false
  	change_column_null :recipes, :description, false
  	change_column_null :recipes, :recipe_url, false
  end
end
