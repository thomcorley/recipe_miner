# frozen_string_literal: true

RSpec.describe RecipeFinder::JSONSchema do
  include StubRequestSpecHelper

  describe "#find" do
    before(:each) do
      @finder = RecipeFinder::JSONSchema.new(grubdaily_url)
    end

    it "raises an error if passed an invalid URL" do
      recipe_webpage = File.read("spec/test_data/recipe_webpage_full.html")

      expect{ RecipeFinder::JSONSchema.new("not_a_url").recipe_hash }.to raise_error("Invalid URL")
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
        correct_keys_present = keys.all?{ |key| recipe_attributes.include?(key) }

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

          expect{ @finder.recipe_hash }.to raise_error(RecipeFinder::JSONSchema::MissingRecipeAttributesError)
        end
      end
    end

    context "for a webpage that doesn't contain recipe JSON" do
      it "raises an error" do
        recipe_webpage = File.read("spec/test_data/webpage_with_no_recipe_json.html")
        stub_get_request_with(recipe_webpage)

        expect{ @finder.recipe_hash }.to raise_error(RecipeFinder::JSONSchema::NoRecipeJsonFoundError)
      end
    end

    context "for a webpage that contains non-recipe JSON" do
      it "raises an error" do
        recipe_webpage = File.read("spec/test_data/webpage_with_non_recipe_json.html")
        stub_get_request_with(recipe_webpage)

        expect{ @finder.recipe_hash }.to raise_error(RecipeFinder::JSONSchema::NoRecipeJsonFoundError)
      end
    end
  end

  def recipe_attributes
    [:title, :image_url, :total_time, :yield, :description, :rating_value, :rating_count, :recipe_url]
  end
end
