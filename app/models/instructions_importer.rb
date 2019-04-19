# frozen_string_literal: true

class InstructionsImporter

  attr_reader :instructions, :recipe_id

  def initialize(instructions, recipe_id)
    @instructions = instructions
    @recipe_id = recipe_id
    @logger = Rails.logger
  end

  def import
    if instructions.nil?
      @logger.info("No instructions available")
      return
    end

    if instructions.is_a?(Array)
      import_array_of_instructions(instructions)
    elsif instructions.is_a?(String)
      import_string_of_instructions_with_newlines(instructions)
    end

    @logger.info("Successfully got instructions")
  rescue StandardError => e
    @logger.info("Error: could not add instructions: #{e}")
    raise e
  end

  private

  def import_array_of_instructions(array)
    array.each_with_index do |instruction, index|
      next if control_character?(instruction)
      position = index + 1
      Instruction.create!(position: position, description: instruction, recipe_id: recipe_id)
    end
  end

  def import_string_of_instructions_with_newlines(string)
    if instructions.match?(/\n/)
      instructions.split("\n").each_with_index do |instruction, index|
        next if control_character?(instruction)
        position = index + 1
        Instruction.create!(position: position, description: instruction, recipe_id: recipe_id)
      end
    else # assume there is only one instuction and it's on one line
      return if control_character?(instruction)
      Instruction.create!(position: 1, description: instructions, recipe_id: recipe_id)
    end
  end

  def control_character?(string)
    ["\n", "\r", "\t", "\r\n"].include?(string)
  end
end
