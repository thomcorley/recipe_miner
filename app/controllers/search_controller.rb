# frozen_string_literal: true

class SearchController < ApplicationController
  def search
    search_params = params[:query]

    if search_params
      ingredients = search_params.delete(" ","").split(" ")

      @recipes = Recipe.joins(:ingredients)
        .where("recipes.title LIKE ?", "%#{ingredients.first}%")
        .uniq
        .first(10)
    end

    respond_to do |format|
      format.json do
        render json: @recipes , include: [:ingredients, :instructions]
      end
    end
  end

  def search_params
    params.require(:search).permit!
  end
end
