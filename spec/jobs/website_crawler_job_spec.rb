require 'rails_helper'

RSpec.describe WebsiteCrawlerJob, type: :job do
	
	describe "#perform" do
	  let(:website_url) { "https://www.grubdaily.com" }

	  it "performs successfully" do	    
	    expect_any_instance_of(WebsiteCrawler).to receive(:crawl)

	    WebsiteCrawlerJob.new(website_url).perform
	  end
	end
end
