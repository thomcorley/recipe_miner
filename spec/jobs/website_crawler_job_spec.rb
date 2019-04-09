# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WebsiteCrawlerJob, type: :job do
  include StubRequestSpecHelper

  describe "#perform" do
    it "performs successfully" do
      expect_any_instance_of(WebpageCrawler).to receive(:crawl)

      WebpageCrawlerJob.new(grubdaily_url).perform
    end
  end
end
