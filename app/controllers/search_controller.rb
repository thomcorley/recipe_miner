class SearchController < ApplicationController
  def search
  	search_params = params[:search]
  	if search_params
  		ingredient = search_params.gsub(" ","").split(",")
  		@recipes = Recipe.joins(:ingredients).where("ingredients.description LIKE ?", "%#{ingredient.first}%").uniq
  	end
  end

  def search_params
  	params.require(:search).permit!
  end
end
