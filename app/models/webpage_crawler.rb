# frozen_string_literal: true

class WebpageCrawler
  attr_reader :recipe_hash

  # TODO: make this class more general: it should not know about the format of the keys of the recipe_hash
  def initialize(url)
    @url = url
    @logger = Rails.logger
  end

  def crawl
    if recipe_exists?(@url)
      @logger.info("Recipe already exists")
      return
    end

    @recipe_hash = RecipeFinder::JSONSchema.new(@url).recipe_hash

    if recipe_hash
      process_recipe
    else
      @logger.info("Couldn't find a recipe in this webpage")
    end
  end

  private

  def recipe_exists?(url)
    Recipe.where(recipe_url: url).any?
  end

  def process_recipe
    recipe = import_recipe
    import_ingredients(recipe_id: recipe.id)
    import_instructions(recipe_id: recipe.id)
  rescue StandardError => e
    raise e
    @logger.info("Error: Could not add recipe: #{e}")
  end

  def import_recipe
    formatted_recipe_hash = recipe_hash.deep_symbolize_keys.merge(recipe_url: @url)
    RecipeImporter.new(formatted_recipe_hash).import
  end

  def import_ingredients(recipe_id:)
    ingredients = recipe_hash[:recipeIngredient]
    IngredientsImporter.new(ingredients, recipe_id).import
  end

  def import_instructions(recipe_id:)
    instructions = recipe_hash[:recipeInstructions]
    InstructionsImporter.new(instructions, recipe_id).import
  end
end
