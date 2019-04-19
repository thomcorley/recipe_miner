# frozen_string_literal: truee

RSpec.describe InstructionsImporter do
  describe "#import" do
    it "imports an array of ingredients" do
      instructions = ["Chop onions", "Add stock", "Simmer for 3 hours"]
      recipe = create(:recipe)

      expect{ InstructionsImporter.new(instructions, recipe.id).import }.to change{ Instruction.count }.by(3)
    end
  end
end
