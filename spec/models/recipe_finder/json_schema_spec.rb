# frozen_string_literal: true
require "rails_helper"

describe RecipeFinder::JsonSchema do
  include StubRequestSpecHelper

  describe "#recipe_hash" do
    before(:each) do
      @finder = RecipeFinder::JsonSchema.new(grubdaily_url)
    end

    it "raises an error if passed an invalid URL" do
      expect{ RecipeFinder::JsonSchema.new("not_a_url").recipe_hash }.to raise_error("Invalid URL")
    end

    context "for a webpage that contains recipe JSON" do
      let(:recipe_webpage) { File.read("spec/test_data/recipe_webpage_full.html") }

      it "returns a hash" do
        stub_get_request_with(recipe_webpage)

        expect(@finder.recipe_hash).to be_a(Hash)
      end

      it "returns a hash with the correct keys" do
        stub_get_request_with(recipe_webpage)

        keys = @finder.recipe_hash.keys
        correct_keys_present = keys.all?{ |key| Recipe::FULL_ATTRIBUTES.include?(key) }

        expect(correct_keys_present).to be true
      end

      context "when the JSON contains the minimum information for a recipe" do
        it "returns a hash with the expected keys" do
          minimum_keys = [:title, :image_url, :total_time, :yield, :recipe_url]
          stub_get_request_with(recipe_webpage)
          keys = @finder.recipe_hash.keys

          expect(minimum_keys - keys).to be_empty
        end
      end

      context "when the JSON doesn't contain the minimum expected keys" do
        it "raises an error" do
          broken_webpage = File.read("spec/test_data/recipe_webpage_missing_json_keys.html")
          stub_get_request_with(broken_webpage)

          expect{ @finder.recipe_hash }.to raise_error(RecipeFinder::JsonSchema::MissingRecipeAttributesError)
        end
      end
    end

    context "for a webpage that doesn't contain recipe JSON" do
      it "raises an error" do
        recipe_webpage = File.read("spec/test_data/webpage_with_no_recipe_json.html")
        stub_get_request_with(recipe_webpage)

        expect{ @finder.recipe_hash }.to raise_error(RecipeFinder::JsonSchema::NoRecipeJsonFoundError)
      end
    end

    context "for a webpage that contains non-recipe JSON" do
      it "raises an error" do
        recipe_webpage = File.read("spec/test_data/webpage_with_non_recipe_json.html")
        stub_get_request_with(recipe_webpage)

        expect{ @finder.recipe_hash }.to raise_error(RecipeFinder::JsonSchema::NoRecipeJsonFoundError)
      end
    end

    context "for a recipe that has mutiple images in an array" do
      it "gets the first image" do
        recipe_webpage = File.read("spec/test_data/recipe_with_multiple_images.html")
        stub_get_request_with(recipe_webpage)
        recipe_hash = RecipeFinder::JsonSchema.new(grubdaily_url).recipe_hash

        expect(recipe_hash[:image_url])
          .to eq("https://s3.eu-west-2.amazonaws.com/grubdaily/cavolo-nero-parmesan-salad.jpg")
      end
    end

    context "for a recipe that has an image JSON object" do
      it "gets the url of the image correctly" do
        recipe_webpage = File.read("spec/test_data/recipe_webpage_with_image_object.html")
        stub_get_request_with(recipe_webpage)
        recipe_hash = RecipeFinder::JsonSchema.new(grubdaily_url).recipe_hash

        expect(recipe_hash[:image_url])
          .to eq("https://www.gordonramsay.com/whole-Chicken-1157.jpg")
      end
    end
  end
end
