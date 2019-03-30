# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RecipeMiner, type: :model do

  describe "#start_mining" do
    it "enqueues the website crawler job" do
      website_list = "lib/test_website_directory.txt"
      expect(WebsiteCrawlerJob).to receive(:schedule).once

      RecipeMiner.start_mining(website_list)
    end
  end
end
