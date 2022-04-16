# frozen_string_literal: true
module SearchSpecHelper
  def bulk_create_recipe_data
    recipe_json = File.read(File.expand_path("../../test_data/recipes.json", __dir__))
    recipe_data = JSON.parse(recipe_json)

    recipe_data.each_with_index do |r, index|
      recipe = Recipe.create(
        title: r["title"],
        image_url: "www.example.com/images/1",
        total_time: r["totalTime"],
        rating_value: r["ratingValue"],
        rating_count: r["ratingCount"],
        description: r["description"],
        recipe_url: "https://www.grubdaily.com/recipes/#{index + 1}",
      )

      r["ingredientEntries"].each_with_index do |ingredient, index|
        next if ingredient.blank?
        recipe.ingredients.create!(description: ingredient, position: index + 1)
      end

      r["instructions"].each_with_index do |instruction, index|
        next if instruction.blank?
        recipe.instructions.create!(description: instruction, position: index + 1)
      end
    end
  end
end
