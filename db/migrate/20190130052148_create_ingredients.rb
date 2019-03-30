# frozen_string_literal: true

class CreateIngredients < ActiveRecord::Migration[5.1]
  def change
    create_table :ingredients do |t|
      t.integer :position
      t.text :description
      t.references :recipe, foreign_key: true

      t.timestamps
    end
  end
end
