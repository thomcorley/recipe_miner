# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Recipe, type: :model do
  context "when creating a recipe" do
    it "validates that the recipe has a unique url" do
      recipe1 = FactoryBot.create(:recipe, recipe_url: "https://www.grubdaily.com/amp/tomato-soup")
      recipe2 = FactoryBot.build(:recipe, recipe_url: "https://www.grubdaily.com/amp/tomato-soup")

      expect(recipe2).to be_invalid
    end

    let(:recipe2) { FactoryBot.create(:recipe, recipe_url: "https://www.grubdaily.com/tomato-soup") }

    it "deletes itself if there is another recipe with an amp version of the same url" do
      recipe1 = FactoryBot.create(:recipe, recipe_url: "https://www.grubdaily.com/amp/tomato-soup")

      expect{ recipe2 }.to raise_error Recipe::AmpRecipeDetectedError
    end

    it "deletes another non-amp version of the same recipe if there is one" do
      recipe1 = FactoryBot.create(:recipe, recipe_url: "https://www.grubdaily.com/swedish-meatballs")
      recipe2 = FactoryBot.create(:recipe, recipe_url: "https://www.grubdaily.com/swedish-meatballs/amp")

      expect{ recipe1.reload }.to raise_error ActiveRecord::RecordNotFound
    end
  end

  xdescribe "#human_readable_time" do
    context "converting from ISO time format" do
      let(:recipe) { FactoryBot.create(:recipe) }

      it "handles days" do
        recipe.update!(total_time: "P2D")
        expect(recipe.human_readable_time).to eq("2 days")
      end

      it "handles hours" do
        recipe.update!(total_time: "PT4H")
        expect(recipe.human_readable_time).to eq("4 hours")
      end

      it "handles minutes" do
        recipe.update!(total_time: "PT30M")
        expect(recipe.human_readable_time).to eq("30 minutes")
      end

      it "handles hours and minutes" do
        recipe.update!(total_time: "PT1H30M")
        expect(recipe.human_readable_time).to eq("1 hour 30 minutes")
      end
    end
  end
end
