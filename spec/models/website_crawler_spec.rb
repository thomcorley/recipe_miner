require 'rails_helper'

RSpec.describe WebsiteCrawler, type: :model do
  describe "#has_sitemap?" do
  	let(:with_map) { WebsiteCrawler.new("https://www.grubdaily.com") }
  	let(:with_no_map) { WebsiteCrawler.new("https://www.allrecipes.com") }
  	
  	it "detects a website that has a sitemap" do  	
	  	expect(with_map.has_sitemap?).to be true
	  	expect(with_no_map.has_sitemap?).to be false
	  end
  end
end
