# frozen_string_literal: true

class Ingredient < ApplicationRecord
  belongs_to :recipe

  validates_presence_of :position, :description
end
