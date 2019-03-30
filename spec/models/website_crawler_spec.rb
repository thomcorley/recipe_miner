# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WebsiteCrawler, type: :model do
  describe "#has_sitemap?" do
    let(:with_map) { WebsiteCrawler.new("https://www.grubdaily.com") }
    let(:with_no_map) { WebsiteCrawler.new("https://www.allrecipes.com") }
  end
end
