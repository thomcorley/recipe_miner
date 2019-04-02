# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WebpageCrawlerJob, type: :job do

  describe "#perform" do
    let(:website_url) { "https://www.grubdaily.com" }

    it "performs successfully" do
      expect_any_instance_of(WebpageCrawler).to receive(:crawl)

      WebpageCrawlerJob.new(website_url).perform
    end
  end
end
