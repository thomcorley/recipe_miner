class AmendNullConstraintsOnRecipeTable < ActiveRecord::Migration[5.1]
  def change
  	change_column_null :recipes, :description, true
  	change_column_null :recipes, :recipe_url, false
  end
end
