# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WebpageCrawler do

  setup do
    @crawler = WebpageCrawler.new("https://www.grubdaily.com/cavolo-nero-parmesan-salad")
  end

  describe "#crawl" do
    context "for a webpage with JSON recipe schema" do
      it "saves a recipe" do
        stub_recipe_json = File.read("spec/test_data/basic_recipe.json")
        allow_any_instance_of(RecipeJsonFinder).to receive(:find).and_return(stub_recipe_json)
        expect{ @crawler.crawl }.to change{ Recipe.count }.by(1)

        @crawler.crawl
      end

      it "saves ingredients" do
        stub_recipe_json = File.read("spec/test_data/basic_recipe.json")
        allow_any_instance_of(RecipeJsonFinder).to receive(:find).and_return(stub_recipe_json)

        expect{ @crawler.crawl }.to change{ Ingredient.count }.by(4)
      end

      it "saves instructions" do
        stub_recipe_json = File.read("spec/test_data/basic_recipe.json")
        allow_any_instance_of(RecipeJsonFinder).to receive(:find).and_return(stub_recipe_json)

        expect{ @crawler.crawl }.to change{ Instruction.count }.by(2)
      end
    end

    context "for a webpage without JSON recipe schema" do
      it "doesn't save a recipe" do
        allow_any_instance_of(RecipeJsonFinder).to receive(:find).
          and_return(nil)

        expect{ @crawler.crawl }.not_to change{ Recipe.count }

        @crawler.crawl
      end

      it "logs a message" do
        allow_any_instance_of(RecipeJsonFinder).to receive(:find).
          and_return(nil)

        expect(Rails.logger).to receive(:info).with("Couldn't find a recipe in this webpage")

        @crawler.crawl
      end
    end
  end
end
