# frozen_string_literal: true

class WebsiteCrawler
  def initialize(url:)
    @url = url
    @logger = Rails.logger
  end

  def crawl
    if sitemap_response_code != 200
      @logger.info("Could not crawl website: sitemap not available")
      return
    end

    webpage_urls = SitemapParser.new(sitemap_url).array_of_urls

    webpage_urls.each do |url|
      WebpageCrawlerJob.schedule(url)
    end
  end

  private

  def sitemap_response_code
    HttpRequest::Get.new(url: sitemap_url).code
  end

  def sitemap_url
    @url + "/sitemap.xml"
  end
end
