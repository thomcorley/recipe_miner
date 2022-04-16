# frozen_string_literal: true
class SearchController < ApplicationController
  def search
    search_params = params[:query]

    if search_params
      @recipes = RecipeSearch.new(query: search_params).result
    end

    respond_to do |format|
      format.json do
        render json: @recipes, include: [:ingredients, :instructions]
      end
    end
  end

  def search_params
    params.require(:search).permit!
  end
end
