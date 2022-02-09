# frozen_string_literal: true

class RemoveTextFromRecipes < ActiveRecord::Migration[5.1]
  def change
    remove_column :recipes, :text, :string
  end
end
