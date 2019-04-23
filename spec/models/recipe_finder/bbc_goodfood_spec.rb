# frozen_string_literal: true

module RecipeFinder
  class BBCGoodFood
    def initialize(url)
      @url = url
    end

    def recipe_hash
      webpage_body = HttpRequest::Get.new(@url).body
      title_element = Nokogiri(webpage_body).css("title")
      title = title_element.text.gsub(" recipe | BBC Good Food", "")

      script_elements = Nokogiri(webpage_body).css("script")

      recipe_meta_element = script_elements.select do |element|
        element.text =~ /permutive\.addon\((.*);/
      end.first

      raw_recipe_meta_data = recipe_meta_element.text
      recipe_meta_data = raw_recipe_meta_data.match(/permutive\.addon\('web',(?<hash>.*)\);/).named_captures
      hash_of_recipe_data = recipe_meta_data["hash"]


      total_time = hash_of_recipe_data["prep_time"] + hash_of_recipe_data["cooking_time"]

      {
        title: title,
        image_url: nil,
        total_time: total_time,
        yield: nil,
        description: nil,
        rating_value: nil,
        rating_count: nil,
        recipe_url: nil,
        ingredients: nil,
        instructions: nil
      }
    end
  end
end


# frozen_string_literal: true

describe RecipeFinder::BBCGoodFood do
  include StubRequestSpecHelper

  describe "#recipe_hash" do
    it "returns the title of the recipe" do
      webpage_body = File.read("spec/test_data/bbcgoodfood_webpage.html")
      allow_any_instance_of(HttpRequest::Get).to receive(:body).and_return(webpage_body)
      recipe_hash = RecipeFinder::BBCGoodFood.new(grubdaily_url).recipe_hash

      expect(recipe_hash[:title]).to eq("Crackling potato cake")
    end

    it "gets the recipe meta information" do
      webpage_body = File.read("spec/test_data/bbcgoodfood_webpage.html")
      allow_any_instance_of(HttpRequest::Get).to receive(:body).and_return(webpage_body)
      recipe_hash = RecipeFinder::BBCGoodFood.new(grubdaily_url).recipe_hash

      expect(recipe_hash[:total_time]).to eq("6600")
    end
  end
end
