require 'rails_helper'

RSpec.describe HomeController, type: :controller do
	describe "GET index" do
		before(:each) { get :index }

		it "returns a 200" do
			expect(response).to have_http_status(:ok)
		end

		it "renders the index view" do
			expect(response).to render_template("index")
		end

		it "assigns @recipe_count" do
			expect(assigns(:recipe_count)).to be_a(Integer)
		end
	end

	describe "GET start_mining" do
		it "schedules a RecipeMinerJob" do
			expect(RecipeMinerJob).to receive(:schedule)
			get :start_mining
		end

		it "displays a flash message" do
			get :start_mining
			expect(flash[:notice]).to be_present
		end

		it "redirects to the root url" do
			get :start_mining
			expect(response).to redirect_to("/")
		end
	end
end
