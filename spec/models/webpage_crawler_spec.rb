# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WebpageCrawler, type: :model do

  include CrawlerSpecHelper

  setup do
    @crawler = WebpageCrawler.new("https://www.grubdaily.com/cavolo-nero-parmesan-salad")
    file = File.read("spec/test_data/basic_recipe.json")
    @recipe_hash = JSON.parse(file).deep_symbolize_keys
  end

  describe "#parse_recipe_json" do
    let(:parse_recipe) { @crawler.parse_recipe_json(@recipe_hash) }

    it "saves a recipe" do
      expect { parse_recipe }.to change { Recipe.count }.by 1
    end
  end

  describe "#save_recipe" do
    it "has the correct recipe url" do
      recipe = @crawler.save_recipe(@recipe_hash)
      correct_url = "https://www.grubdaily.com/cavolo-nero-parmesan-salad"

      expect(recipe.recipe_url).to eq(correct_url)
    end

    it "handles multiple images" do
      json = File.read("spec/test_data/recipe_with_multiple_images.json")
      recipe_hash = JSON.parse(json).deep_symbolize_keys
      recipe = @crawler.save_recipe(recipe_hash)

      expect(recipe.image_url).to eq "https://s3.eu-west-2.amazonaws.com/grubdaily/lamb_bolognese.jpg"
    end

    it "saves a recipe with no instructions" do
      json = File.read("spec/test_data/recipe_with_no_instructions.json")
      recipe_hash = JSON.parse(json).deep_symbolize_keys

      expect { @crawler.save_recipe(recipe_hash) }.to change { Recipe.count }.by 1
    end
  end

  describe "#is_a_recipe_schema" do
    it "returns true for a valid recipe schema" do
      is_schema = @crawler.is_a_recipe_schema?("application/ld+json", "Recipe")

      expect(is_schema).to be true
    end

    it "returns false for a schema of a different type" do
      is_schema = @crawler.is_a_recipe_schema?("application/ld+json", "Horse")

      expect(is_schema).to be false
    end
  end

  describe "#save_ingredients" do
    let(:recipe) { FactoryBot.create(:recipe) }
    let(:webpage_crawler) { WebpageCrawler.new("https://www.grubdaily.com/classic-omelette.jpg") }

    it "handles an array of ingredients" do
      webpage_crawler.save_ingredients(@recipe_hash, recipe.id)
      expect(recipe.reload.ingredients.count).to eq 4
    end
  end

  describe "#save_instructions" do
    let(:recipe) { FactoryBot.create(:recipe) }
    let(:webpage_crawler) { WebpageCrawler.new("https://www.grubdaily.com/classic-omelette.jpg") }

    it "parses instructions separated by newline characters" do
      @recipe_hash[:recipeInstructions] = "Instructions separated\nby newline\ncharacters"
      webpage_crawler.save_instructions(@recipe_hash, recipe.id)

      expect(recipe.reload.instructions.count).to eq 3
    end
  end
end
