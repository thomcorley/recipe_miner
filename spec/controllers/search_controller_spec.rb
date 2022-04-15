# frozen_string_literal: true
require "rails_helper"

describe SearchController do
  include SearchSpecHelper

  describe "GET search" do
    before(:all) { bulk_create_recipe_data }
    before(:each) { get :search, params: { query: query }, format: :json }
    after(:all) { Recipe.destroy_all }

    context "with no search query" do
      let(:query) { "" }

      it "returns a list of 10 recipes" do
        expect(response).to be_successful
        expect(response.parsed_body.count).to eq(10)
      end
    end

    context "a single search query" do
      context "query matches recipe title" do
        let(:vindaloo_recipes) do
          [
            "Cauliflower Vindaloo",
            "Chicken Vindaloo",
            "Pork Vindaloo",
            "Runner Bean Vindaloo",
          ]
        end

        context "capitalised" do
          let(:query) { "Vindaloo" }

          it "returns the expected recipes" do
            recipes = response.parsed_body.map{ |r| r["title"] }.sort
            expect(recipes).to eq(vindaloo_recipes)
          end
        end

        context "case insensitive" do
          let(:query) { "vindaloo" }

          it "returns the expected recipes" do
            recipes = response.parsed_body.map{ |r| r["title"] }.sort
            expect(recipes).to eq(vindaloo_recipes)
          end
        end

        context "query contained in ingredients" do
          let(:query) { "peppercorns" }

          let(:peppercorn_recipes) do
            [
              "Chicken and Coriander Broth",
              "Dry Cured Bacon",
              "Duck Rillettes",
              "Macaroni Cheese",
              "Pea and Ham Soup",
              "Pickled Girolles",
              "Pork Vindaloo",
              "Puerco Pibil",
              "Salmon and Hollandaise",
            ]
          end

          it "returns the expected recipes" do
            recipes = response.parsed_body.map{ |r| r["title"] }.sort
            expect(recipes).to eq(peppercorn_recipes)
          end
        end

        context "some recipes with query in title, and some with it in the ingredients" do
          let(:query) { "chicken" }

          let(:chicken_recipes) do
            [
              "Barley Risotto with Chicken",
              "Chicken and Coriander Broth",
              "Chicken and Pancetta",
              "Chicken and Smoked Ham Pie",
              "Chicken Caesar Salad",
              "Chicken Confit with Lemon Dressing",
              "Chicken Vindaloo",
              "Cured Chicken Leg with Butter Beans",
              "Cured Chicken Leg with Jersey Royals",
              "Roast Chicken Leg with Coriander",
            ]
          end

          it "returns the expected recipes" do
            recipes = response.parsed_body.map{ |r| r["title"] }.sort_by(&:downcase)
            expect(recipes).to eq(chicken_recipes)
          end
        end
      end

      context "query contained only in the recipe introduction" do
          let(:query) { "Scotland" }

          let(:scotland_recipes) do
            [
              "Arbroath Smoky",
              "Girolles on toast",
              "Granny's Spelt Bread",
              "Salmon Tartare",
            ]
          end

          it "returns the expected recipes" do
            recipes = response.parsed_body.map{ |r| r["title"] }.sort
            expect(recipes).to eq(scotland_recipes)
          end
      end
    end

    context "recipes containing 5 different ingredients" do
      let(:query) { "carrot onion garlic bacon celery" }

      let(:expected_recipes) do
        [
          "Lamb Bolognese",
          "Mulligatawny Soup",
          "Mum's Tomato Soup",
          "Spaghetti Bolognese",
          "Winter Minestrone"
        ]
      end

      it "returns the expected recipes" do
        recipes = response.parsed_body.map{ |r| r["title"] }.sort
        expect(recipes).to eq(expected_recipes)
      end
    end

    context "recipes containing 7 different ingredients" do
      let(:query) { "carrot onion garlic bacon celery wine thyme" }
      let(:expected_recipes) { ["Lamb Bolognese", "Spaghetti Bolognese"] }

      it "returns the expected recipes" do
        recipes = response.parsed_body.map{ |r| r["title"] }.sort
        expect(recipes).to eq(expected_recipes)
      end
    end
  end
end
