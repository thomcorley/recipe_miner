# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RecipeMiner, type: :model do
  describe "#start_crawling_websites" do
    it "enqueues the website crawler job" do
      expect(WebsiteCrawlerJob).to receive(:schedule)

      recipe_miner = RecipeMiner.new(directory: "lib/test_website_directory.txt")
      recipe_miner.start_crawling_websites
    end

    it "raises an error if no directory is given" do
      recipe_miner = RecipeMiner.new(directory: nil)

      expect{ recipe_miner.start_crawling_websites }.to raise_error(RuntimeError)
    end
  end
end
