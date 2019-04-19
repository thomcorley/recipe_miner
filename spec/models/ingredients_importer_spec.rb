# frozen_string_literal: true

RSpec.describe IngredientsImporter do
  context "#import" do
    it "imports an array of ingredients" do
      ingredients = ["2 carrots", "1 onion"]
      recipe = create(:recipe)

      expect{ IngredientsImporter.new(ingredients, recipe.id).import }.to change{ Ingredient.count }.by(2)
    end
  end
end
