# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WebpageCrawler do

  setup do
    @crawler = WebpageCrawler.new("https://www.grubdaily.com/cavolo-nero-parmesan-salad")
  end

  describe "#crawl" do
    context "for a webpage with JSON recipe schema" do
      let(:recipe) { create(:recipe) }
      let(:stub_recipe_hash) { stub_recipe_json = JSON.parse(File.read("spec/test_data/basic_recipe.json")) }

      it "imports a recipe" do
        allow_any_instance_of(RecipeFinder::JSONSchema).to receive(:recipe_hash).and_return(stub_recipe_hash)
        allow_any_instance_of(IngredientsImporter).to receive(:import).and_return(true)

        expect_any_instance_of(RecipeImporter).to receive(:import).and_return(recipe)

        @crawler.crawl
      end

      it "doesn't import a recipe if it exists already"

      it "imports ingredients" do
        allow_any_instance_of(RecipeFinder::JSONSchema).to receive(:recipe_hash).and_return(stub_recipe_hash)
        expect_any_instance_of(IngredientsImporter).to receive(:import)

        @crawler.crawl
      end

      it "imports instructions" do
        allow_any_instance_of(RecipeFinder::JSONSchema).to receive(:recipe_hash).and_return(stub_recipe_hash)
        allow_any_instance_of(IngredientsImporter).to receive(:import).and_return(true)

        expect_any_instance_of(InstructionsImporter).to receive(:import)

        @crawler.crawl
      end
    end

    context "for a webpage without JSON recipe schema" do
      it "doesn't save a recipe" do
        allow_any_instance_of(RecipeFinder::JSONSchema).to receive(:recipe_hash).
          and_return(nil)

        expect{ @crawler.crawl }.not_to change{ Recipe.count }

        @crawler.crawl
      end

      it "logs a message" do
        allow_any_instance_of(RecipeFinder::JSONSchema).to receive(:recipe_hash).
          and_return(nil)

        expect(Rails.logger).to receive(:info).with("Couldn't find a recipe in this webpage")

        @crawler.crawl
      end
    end
  end
end
