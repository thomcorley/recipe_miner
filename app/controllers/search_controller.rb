# frozen_string_literal: true

class SearchController < ApplicationController
  def search
    search_params = params[:search]
    if search_params
      ingredient = search_params.delete(" ","").split(",")
      @recipes = Recipe.joins(:ingredients)
        .where("ingredients.description LIKE ?", "%#{ingredient.first}%")
        .uniq
        .first(20)
    end
  end

  def search_params
    params.require(:search).permit!
  end
end
