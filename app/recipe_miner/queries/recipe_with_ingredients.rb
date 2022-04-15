# frozen_string_literal: true
module Queries
  class RecipeWithIngredients
    def initialize(ingredients:)
      @ingredients = ingredients
    end

    def result
      recipe_groups = aggregated_ingredients_by_recipe_id.select do |group|
        string = group.last.join(" ")
        ingredients.all? { |ingredient| string =~ /#{ingredient}/ }
      end

      Recipe.find(recipe_groups.map(&:first))
    end

    private

    # Returns a list of recipe IDs and their corresponding ingredients:
    #
    # [
    #  [21, ["180g  smoked salted bacon lardons", "10 silver skin onions, peeled"]],
    #  [22, ["4  garlic cloves, finely minced", "2 spring onions, finely chopped"]]
    # ]
    def aggregated_ingredients_by_recipe_id
      Ingredient.joins(:recipe)
                .where("ingredients.description ~ ?", "#{ingredients.join("|")}")
                .group(:recipe_id)
                .pluck(:recipe_id, "ARRAY_AGG(ingredients.description)")
    end

    attr_reader :ingredients
  end
end
