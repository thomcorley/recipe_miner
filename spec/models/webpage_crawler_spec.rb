# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WebpageCrawler do
  setup do
    @crawler = WebpageCrawler.new("https://www.grubdaily.com/onion-soup")
  end

  before(:each) { Recipe.all.each(&:destroy) }

  describe "#crawl" do
    context "for a webpage with JSON recipe schema" do
      it "imports a recipe" do
        allow_any_instance_of(RecipeFinder::JSONSchema).to receive(:recipe_hash).and_return(example_recipe_hash)
        expected_recipe_params = example_recipe_hash.except(:ingredients, :instructions)

        expect{ @crawler.crawl }.to change{ Recipe.count }.by(1)
      end

      it "doesn't import a recipe if it exists already" do
        allow_any_instance_of(RecipeFinder::JSONSchema).to receive(:recipe_hash).and_return(example_recipe_hash)
        FactoryBot.create(:recipe)

        expect{ @crawler.crawl }.not_to change{ Recipe.count }
      end

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

    context "selecting the correct recipe finder" do
      it "selects BbcGoodFood finder for a BbcGoodFood url" do
        bbc_goodfood_crawler = WebpageCrawler.new("https://www.BbcGoodFood.com")
        allow_any_instance_of(HttpRequest::Get).to receive(:body).and_return("YES")
        expect_any_instance_of(RecipeFinder::BbcGoodFood).to receive(:recipe_hash)

        bbc_goodfood_crawler.crawl
      end

      it "selects JSONSchema finder for a grubdaily url" do
        grubdaily_crawler = WebpageCrawler.new("https://www.grubdaily.com")
        allow_any_instance_of(HttpRequest::Get).to receive(:body).and_return("YES")
        expect_any_instance_of(RecipeFinder::JSONSchema).to receive(:recipe_hash)

        grubdaily_crawler.crawl
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
