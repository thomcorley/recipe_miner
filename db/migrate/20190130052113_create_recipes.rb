# frozen_string_literal: true

class CreateRecipes < ActiveRecord::Migration[5.1]
  def change
    create_table :recipes do |t|
      t.string :title
      t.string :image_url
      t.string :total_time
      t.string :yield
      t.string :description
      t.string :text
      t.integer :rating_value
      t.integer :rating_count

      t.timestamps
    end
  end
end
