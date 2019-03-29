require 'rails_helper'

RSpec.describe HomeController, type: :controller do
	describe "#index" do
		it "returns a 200" do
			expect(response.code).to eq "200"
		end

		it "renders the index view template" do
			expect(response).to render_template(:new)
		end

		it "instantiates a Recipe" do

		end
	end
end
