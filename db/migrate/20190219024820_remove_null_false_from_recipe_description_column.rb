class RemoveNullFalseFromRecipeDescriptionColumn < ActiveRecord::Migration[5.1]
  def change
  	change_column_null :recipes, :recipe_url, true
  end
end
