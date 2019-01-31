class AddRecipeUrlToRecipes < ActiveRecord::Migration[5.1]
  def change
    add_column :recipes, :recipe_url, :string
  end
end
