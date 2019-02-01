require 'rails_helper'

RSpec.describe RecipeMiner, type: :model do
	
	describe "#start_mining" do
		it "enqueues the website crawler job" do
			expect(WebsiteCrawlerJob).to receive(:schedule).once

			RecipeMiner.start_mining
		end
	end
end
