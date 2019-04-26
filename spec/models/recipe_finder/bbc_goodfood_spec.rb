# frozen_string_literal: true

require "rails_helper"

RSpec.describe RecipeFinder::BBCGoodFood do
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

      expect(recipe_hash[:total_time]).to eq(6600)
    end

    it "gets the image url" do
      webpage_body = File.read("spec/test_data/bbcgoodfood_webpage.html")
      allow_any_instance_of(HttpRequest::Get).to receive(:body).and_return(webpage_body)
      recipe_hash = RecipeFinder::BBCGoodFood.new(grubdaily_url).recipe_hash

      expect(recipe_hash[:image_url]).to eq("https://www.bbcgoodfood.com/potato-cake.jpg")
    end
  end
end
