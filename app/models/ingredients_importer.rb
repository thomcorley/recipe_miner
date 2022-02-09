# frozen_string_literal: true

class IngredientsImporter

  def initialize(ingredients, recipe_id)
    @ingredients = ingredients
    @recipe_id = recipe_id
    @logger = Rails.logger
  end

  def import
    @ingredients.each_with_index do |ingredient, index|
      position = index + 1
      Ingredient.create!(position: position, description: ingredient, recipe_id: @recipe_id)
    end
    @logger.info("Successfully got ingredients")
  rescue StandardError => e
    @logger.info("Error: Could not add recipe: #{e}")
    raise e
  end
end
