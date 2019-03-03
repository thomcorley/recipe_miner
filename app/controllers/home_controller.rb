class HomeController < ApplicationController
	
  def index
  	@recipe_count = Recipe.all.count
  end

  def start_mining
  	RecipeMinerJob.schedule
  	flash[:notice] = "Started mining for recipes!"
  	redirect_to "/"
  end
end
