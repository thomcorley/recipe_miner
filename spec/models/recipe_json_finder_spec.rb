# frozen_string_literal: true

RSpec.describe RecipeJsonFinder do
  include StubRequestSpecHelper

  describe "#find" do
    before(:each) do
      @finder = RecipeJsonFinder.new(grubdaily_url)
    end

    it "raises an error if passed an invalid URL" do
      recipe_webpage = File.read("spec/test_data/recipe_webpage_full.html")

      expect{ RecipeJsonFinder.new("not_a_url").find }.to raise_error("Invalid URL")
    end

    context "for a webpage that contains recipe JSON" do
      let(:recipe_webpage) { File.read("spec/test_data/recipe_webpage_full.html") }

      it "returns some JSON" do
        stub_get_request_with(recipe_webpage)

        expect(JSON.parse(@finder.find)).to be_a(Hash)
      end

      context "when the JSON contains the minimum information for a recipe" do
        it "returns a JSON with the expected keys" do
          stub_get_request_with(recipe_webpage)
          keys = JSON.parse(@finder.find).keys

          expect(RecipeJsonFinder::MINIMUM_KEYS - keys).to be_empty
        end
      end

      context "when the JSON doesn't contain the minimum expected keys" do
        it "raises an error" do
          broken_webpage = File.read("spec/test_data/recipe_webpage_missing_json_keys.html")
          stub_get_request_with(broken_webpage)

          expect{ @finder.find }.to raise_error(RecipeJsonFinder::MissingRecipeAttributesError)
        end
      end
    end

    context "for a webpage that doesn't contain recipe JSON" do
      it "raises an error" do
        recipe_webpage = File.read("spec/test_data/webpage_with_no_recipe_json.html")
        stub_get_request_with(recipe_webpage)

        expect{ @finder.find }.to raise_error(RecipeJsonFinder::NoRecipeJsonFoundError)
      end
    end

    context "for a webpage that contains non-recipe JSON" do
      it "raises an error" do
        recipe_webpage = File.read("spec/test_data/webpage_with_non_recipe_json.html")
        stub_get_request_with(recipe_webpage)

        expect{ @finder.find }.to raise_error(RecipeJsonFinder::NoRecipeJsonFoundError)
      end
    end
  end
end
