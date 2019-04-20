# frozen_string_literal: true

class RecipeImporter
  # TODO: make this class more general: it should accept params in only one format
  def initialize(recipe_hash)
    @recipe_hash = recipe_hash
  end

  def import
    recipe_params = @recipe_hash.deep_symbolize_keys

    raise "Missing essential recipe information" unless minimum_params_are_present?(recipe_params)

    img = recipe_params[:image]

    if img.is_a?(Array)
      recipe_params[:image] = img.first
    elsif img.is_a?(Hash) && img[:@type] == "ImageObject"
      recipe_params[:image] = img[:url]
    end

    formatted_recipe_params = sanitize_recipe_params(recipe_params)

    Recipe.create!(formatted_recipe_params)
  end

  private

  def sanitize_recipe_params(params)
    {
      title: detect_param(params, :name),
      image_url: detect_param(params, :image),
      total_time: detect_param(params, :totalTime),
      yield: detect_param(params, :recipeYield),
      description: detect_param(params, :description),
      recipe_url: detect_param(params, :recipe_url)
    }
  end

  def minimum_params_are_present?(params)
    params[:name] && params[:image] && params[:recipeIngredient]
  end

  def detect_param(params, key)
    params[key] ? params[key] : nil
  end
end
