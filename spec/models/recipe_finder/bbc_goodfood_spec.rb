# frozen_string_literal: true

require "rails_helper"

RSpec.describe RecipeFinder::BBCGoodFood do
  include StubRequestSpecHelper

  describe "#recipe_hash" do
    let(:webpage_body) { File.read("spec/test_data/bbcgoodfood_webpage.html") }
    let(:recipe_hash) { RecipeFinder::BBCGoodFood.new(grubdaily_url).recipe_hash }
    before(:each) { allow_any_instance_of(HttpRequest::Get).to receive(:body).and_return(webpage_body) }

    it "gets the title of the recipe" do
      expect(recipe_hash[:title]).to eq("Crackling potato cake")
    end

    it "gets the recipe meta information" do
      expect(recipe_hash[:total_time]).to eq(6600)
    end

    it "gets the image url" do
      expect(recipe_hash[:image_url]).to eq("https://www.bbcgoodfood.com/potato-cake.jpg")
    end

    it "gets the yield" do
      expect(recipe_hash[:yield]).to eq(6)
    end

    it "gets the description" do
      description = "Transform the humble potato cake"
      expect(recipe_hash[:description]).to eq(description)
    end

    it "gets the rating value" do
      expect(recipe_hash[:rating_value]).to eq(5)
    end

    it "gets the rating count" do
      expect(recipe_hash[:rating_count]).to eq(1)
    end

    it "gets the ingredients" do
      ingredients = recipe_hash[:ingredients]

      expect(ingredients[0]).to eq("1.2kg Maris Piper potatoes")
      expect(ingredients[1]).to eq("50g butter, melted")
    end

    it "gets the instructions" do
      instructions = recipe_hash[:instructions]

      expect(instructions[0].first(20)).to eq("Heat oven to 220C/20")
      expect(instructions[1].first(31)).to eq("Put the pork skin, skin-side up")
    end
  end
end
