# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WebsiteCrawler, type: :model do

  include StubRequestSpecHelper

  describe "#crawl" do
    let!(:default_crawler) { WebsiteCrawler.new }
    let(:default_url) { "https://www.grubdaily.com" }

    it "crawls grubdaily.com by default if no url is given" do
      instance_variable = default_crawler.instance_variable_get(:@url)

      expect(instance_variable).to eq(default_url)
    end

    it "crawls a website if it has a sitemap" do
      sitemap_url = default_url + "/sitemap.xml"
      requester = HttpRequest::Get.new(sitemap_url)
      urls = ["https://www.grubdaily.com/sourdough"]

      stub_200_response_for(sitemap_url)
      allow_any_instance_of(SitemapParser).to receive(:array_of_urls).and_return(urls)

      expect(WebpageCrawlerJob).to receive(:schedule).once

      default_crawler.crawl
    end

    it "doesn't crawl a website with no sitemap" do
      # expect(WebpageCrawlerJob).not_to rece ive(:schedule)
    end
  end
end
