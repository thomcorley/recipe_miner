class HomeController < ApplicationController
	
  def index

  end

  def start_mining
  	RecipeMiner.start_mining
  	flash[:notice] = "Started mining for recipes!"
  	redirect_to "/"
  end
end
