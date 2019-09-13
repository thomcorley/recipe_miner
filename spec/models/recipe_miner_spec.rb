# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RecipeMiner, type: :model do
  include StubRequestSpecHelper

  describe "#start" do
    it "enqueues the website crawler job" do
      expect(WebsiteCrawlerJob).to receive(:schedule)
      stub_200_response_for("https://www.grubdaily.com/sitemap.xml")

      recipe_miner = RecipeMiner.new(directory: "lib/test_website_directory.txt")
      recipe_miner.start
    end

    it "raises an error if no directory is given" do
      recipe_miner = RecipeMiner.new(directory: nil)

      expect{ recipe_miner.start }.to raise_error(RuntimeError)
    end
  end
end
