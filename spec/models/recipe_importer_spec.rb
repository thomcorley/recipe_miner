# frozen_string_literal: true

RSpec.describe RecipeImporter do
  describe "#import" do
    it "imports a recipe" do
      params = JSON.parse(File.read("spec/test_data/basic_recipe.json"))
        .deep_symbolize_keys
        .merge(recipe_url: "https://www.grubdaily.com/new_recipe")

      expect{ RecipeImporter.new(params).import }.to change{ Recipe.count }.by(1)
    end
  end
end
