# frozen_string_literal: true

module RecipeFinder
  class JsonSchema
    # Assumes there is only one recipe on the webpage
    MINIMUM_KEYS = [
      "@type",
      "name",
      "image",
      "totalTime",
      "recipeYield",
      "recipeIngredient",
    ]

    class NoRecipeJsonFoundError < StandardError; end
    class MissingRecipeAttributesError < StandardError; end

    def initialize(url)
      @url = url
    end

    def recipe_hash
      raise "Invalid URL" unless url_is_valid?

      script_elements = Nokogiri(webpage_body).css("script")

      json_elements = script_elements.select do |element|
        element["type"] =~ %r(application\/ld\+json)
      end

      array = json_elements.map(&:text)
      json = array.first

      raise NoRecipeJsonFoundError unless recipe_json_present?(json)
      raise MissingRecipeAttributesError unless minimum_keys_present?(json)

      schema_hash = JSON.parse(json)
      schema_hash["image"] = process_image_attribute(schema_hash["image"])

      standardize_keys(schema_hash)
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

    def process_image_attribute(image)
      if image.is_a?(Array)
        image = image.first
      elsif image.is_a?(Hash) && image["@type"] == "ImageObject"
        image = image["url"]
      else
        image
      end
    end

    def standardize_keys(schema_hash)
      {
        title: schema_hash["name"],
        image_url: schema_hash["image"],
        total_time: schema_hash["cookTime"],
        yield: schema_hash["recipeYield"],
        description: schema_hash["description"],
        recipe_url: @url,
        ingredients: schema_hash["recipeIngredient"],
        instructions: schema_hash["recipeInstructions"]
      }
    end
  end
end
