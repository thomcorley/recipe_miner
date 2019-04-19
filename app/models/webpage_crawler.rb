# frozen_string_literal: true

class WebpageCrawler
  def initialize(url)
    @url = url
    @logger = Rails.logger
  end

  def crawl
    if recipe_exists?(@url)
      @logger.info("Recipe already exists")
      return
    end

    recipe_json = RecipeJsonFinder.new(@url).find

    if recipe_json
      recipe_hash = JSON.parse(recipe_json)
      process_recipe(recipe_hash)
    else
      @logger.info("Couldn't find a recipe in this webpage")
    end
  end

  private

  # There are many schemas which have the same script tag
  # of `application/ld+json` but we only want the ones of type "Recipe"
  def is_a_recipe_schema?(script_element, type)
    script_element == "application/ld+json" &&
    type == "Recipe"
  end

  # Parses the recipe json from the page
  # and saves it to the database
  def process_recipe(recipe_hash)
    recipe_hash = recipe_hash.deep_symbolize_keys

    recipe = save_recipe(recipe_hash)
    save_ingredients(recipe_hash, recipe.id)
    save_instructions(recipe_hash, recipe.id)
  rescue StandardError => e
    raise e
    @logger.info("Error: Could not add recipe: #{e}")
  end

  # `recipe_hash` is the json content of the recipe
  # data, converted to a hash with symbols as keys
  def save_recipe(recipe_hash)
    raise "Missing essential recipe information" unless minimum_params_are_present?(recipe_hash)

    recipe_hash = process_image_url(recipe_hash)

    formatted_recipe_params = sanitize_recipe_params(recipe_hash).merge(recipe_url: @url)

    recipe = Recipe.create!(formatted_recipe_params)
    @logger.info("Successfully got recipe: #{recipe.title}")
    recipe
  end

  def save_ingredients(recipe_hash, recipe_id)
    ingredients_array = recipe_hash[:recipeIngredient]
    begin
      ingredients_array.each_with_index do |ingredient, index|

        position = index + 1
        Ingredient.create!(position: position, description: ingredient, recipe_id: recipe_id)
      end
      @logger.info("Successfully got ingredients")
    rescue StandardError => e
      @logger.info("Error: Could not add recipe: #{e}")
      raise e
    end
  end

  # TODO: refactor this method
  # rubocop:disable Metrics/CyclomaticComplexity
  def save_instructions(recipe_hash, recipe_id)
    instructions = recipe_hash[:recipeInstructions]

    if instructions.nil?
      @logger.info("No instructions available")
      return
    end

    begin
      if instructions.is_a?(Array)
        instructions.each_with_index do |instruction, index|
          next if control_character?(instruction)
          position = index + 1
          Instruction.create!(position: position, description: instruction, recipe_id: recipe_id)
        end
      elsif instructions.is_a?(String)
        if instructions.match?(/\n/)
          instructions.split("\n").each_with_index do |instruction, index|
            next if control_character?(instruction)
            position = index + 1
            Instruction.create!(position: position, description: instruction, recipe_id: recipe_id)
          end
        else
          return if control_character?(instruction)
          Instruction.create!(position: 1, description: instructions, recipe_id: recipe_id)
        end
      end

      @logger.info("Successfully got instructions")
    rescue StandardError => e
      @logger.info("Error: could not add instructions: #{e}")
      raise e
    end
  end

  def sanitize_recipe_params(params)
    {
      title: detect_param(params, :name),
      image_url: detect_param(params, :image),
      total_time: detect_param(params, :totalTime),
      yield: detect_param(params, :recipeYield),
      description: detect_param(params, :description)
    }
  end

  def minimum_params_are_present?(params)
    if params[:name] && params[:image] && params[:recipeIngredient]
      true
    else
      false
    end
  end

  def detect_param(params, key)
    params[key] ? params[key] : nil
  end

  def recipe_exists?(url)
    Recipe.where(recipe_url: url).any?
  end

  def control_character?(string)
    ["\n", "\r", "\t", "\r\n"].include?(string)
  end

  def process_image_url(recipe_hash)
    img = recipe_hash[:image]

    if img.is_a?(Array)
      recipe_hash[:image] = img.first
      recipe_hash
    elsif img.is_a?(Hash) && img[:@type] == "ImageObject"
      recipe_hash[:image] = img[:url]
      recipe_hash
    else
      recipe_hash
    end
  end
end
