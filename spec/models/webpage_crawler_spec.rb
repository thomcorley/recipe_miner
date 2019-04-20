# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WebpageCrawler do
  setup do
    @crawler = WebpageCrawler.new("https://www.grubdaily.com/onion-soup")
  end

  describe "#crawl" do
    context "for a webpage with JSON recipe schema" do
      let(:recipe) { create(:recipe) }

      it "imports a recipe" do
        allow_any_instance_of(RecipeFinder::JSONSchema).to receive(:recipe_hash).and_return(example_recipe_hash)
        expected_recipe_params = example_recipe_hash.except(:ingredients, :instructions)

        expect{ @crawler.crawl }.to change{ Recipe.count }.by(1)
      end

      it "doesn't import a recipe if it exists already"

      it "imports ingredients" do
        allow_any_instance_of(RecipeFinder::JSONSchema).to receive(:recipe_hash).and_return(example_recipe_hash)
        expect{ @crawler.crawl }.to change{ Ingredient.count }.by(2)
      end

      it "imports instructions" do
        allow_any_instance_of(RecipeFinder::JSONSchema).to receive(:recipe_hash).and_return(example_recipe_hash)
        expect{ @crawler.crawl }.to change{ Instruction.count }.by(3)
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

  def example_recipe_hash
    {
      title: "Onion Soup",
      image_url: "https://www.grubdaily.com/onion-soup.jpg",
      total_time: "PT4H",
      yield: 4,
      description: "A french classic",
      rating_value: 5,
      rating_count: 60,
      recipe_url: "https://www.grubdaily.com/onion-soup",
      ingredients: ["5 onions", "1 litre beef stock"],
      instructions: ["Chop onions", "Add stock", "Simmer for 3.5 hours"]
    }
  end
end
