# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WebsiteCrawler, type: :model do
  describe "#crawl" do
    let(:default_crawler) { WebsiteCrawler.new }
    let(:default_url) { default_crawler.url }

    it "crawls grubdaily.com by default if no url is given" do
      instance_variable = default_crawler.instance_variable_get(:@url)

      expect(instance_variable).to eq("https://www.grubdaily.com")
    end

    it "crawls a website if it has a sitemap" do
      default_crawler.crawl
      expect(WebpageCrawlerJob).to receive(:schedule)
    end

    it "doesn't crawl a website with no sitemap" do
      expect(WebpageCrawlerJob).not_to receive(:schedule)
    end
  end
end



    # sitemap = sitemap_response unless sitemap

    # if sitemap_response.code != 200
    #   @logger.info("Could not crawl website: sitemap not available")
    #   return
    # end

    # nokogiri_link_objects = get_links_from_sitemap(sitemap_response.body)

    # # Assuming that if there are less than 50 links in the sitemap
    # # its a sitemap of sitemaps and we have to loop through each link
    # if nokogiri_link_objects.count < 50
    #   nokogiri_link_objects.each do |single_sitemap_object|
    #     inner_sitemap = HTTParty.get(single_sitemap_object.text).body
    #     inner_link_objects = get_links_from_sitemap(inner_sitemap)

    #     inner_link_objects.each do |inner_link_object|
    #       url_of_webpage = inner_link_object.text
    #       WebpageCrawlerJob.schedule(url_of_webpage)
    #     end
    #   end
    # else
    #   nokogiri_link_objects.each do |link_object|
    #     url_of_webpage = link_object.text
    #     WebpageCrawlerJob.schedule(url_of_webpage)
    #   end
    # end
