# frozen_string_literal: true

class RecipeJsonFinder
  # Takes a url and finds the recipe json in it, if there is one
  # Assumes there is only one recipe on the webpage
  MINIMUM_KEYS = [
    "@type",
    "name",
    "image",
    "totalTime",
    "recipeYield",
    "recipeIngredient",
    "recipeInstructions"
  ]

  class NoRecipeJsonFoundError < StandardError; end
  class MissingRecipeAttributesError < StandardError; end

  def initialize(url)
    @url = url
  end

  def find
    raise "Invalid URL" unless url_is_valid?

    script_elements = Nokogiri(webpage_body).css("script")

    json_elements = script_elements.select do |element|
      element["type"] =~ %r(application\/ld\+json)
    end

    array = json_elements.map(&:text)
    json = array.first

    raise NoRecipeJsonFoundError unless recipe_json_present?(json)
    raise MissingRecipeAttributesError unless minimum_keys_present?(json)

    json
  end

  private

  def url_is_valid?
    @url =~ URI::regexp
  end

  def webpage_body
    HttpRequest::Get.new(@url).body
  end

  def recipe_json_present?(json)
    json ? JSON.parse(json)["@type"] == "Recipe" : false
  end

  def minimum_keys_present?(json)
    keys = JSON.parse(json).keys
    MINIMUM_KEYS - keys == []
  end
end
