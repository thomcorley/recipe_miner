# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WebsiteCrawler, type: :model do
  include StubRequestSpecHelper

  describe "#crawl" do
    let(:crawler) { WebsiteCrawler.new(url: grubdaily_url) }

    it "crawls a website if it has a sitemap" do
      requester = HttpRequest::Get.new(url: grubdaily_sitemap_url)
      urls = ["https://www.grubdaily.com/sourdough"]

      stub_200_response_for(grubdaily_sitemap_url)
      allow_any_instance_of(SitemapParser).to receive(:array_of_urls).and_return(urls)
      allow_any_instance_of(HttpRequest::Get).to receive(:code).and_return(200)

      expect(WebpageCrawlerJob).to receive(:schedule).once

      crawler.crawl
    end

    context "crawling a website that doesn't have a sitemap" do
      it "doesn't schedule a WebpageCrawlerJob" do
        allow_any_instance_of(HttpRequest::Get).to receive(:code).
          and_return(404)

        expect(WebpageCrawlerJob).not_to receive(:schedule)

        crawler.crawl
      end

      it "logs the correct message" do
        logger = Rails.logger
        allow_any_instance_of(HttpRequest::Get).to receive(:code).
          and_return(404)

        expect(logger).to receive(:info).with("Could not crawl website: sitemap not available")

        crawler.crawl
      end
    end
  end
end
