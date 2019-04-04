# frozen_string_literal: true

class WebsiteCrawler
  def initialize(url: "https://www.grubdaily.com")
    @url = url
    @logger = Rails.logger
  end

  def crawl
    # Return early if there's no sitemap
    return unless sitemap_response_code == "200"


    # Use the sitemap to generate a list of webpage urls


    # Loop through the list of urls and schedule a webpage crawler job for each
  end

  private

  def sitemap_response_code
    url = construct_url_from(@url) + "/sitemap.xml"
    HttpRequest::Get.new(url).code
  end

  # The url of the recipe website may have subdomains, query string params etc
  # so we want to extract only the plain url.
  def construct_url_from(full_web_address)
    uri = URI.parse(full_web_address.strip)
    uri.scheme + "://" + uri.host
  end

  # Takes the response `.body` from an HTTParty request to the sitemap
  def get_links_from_sitemap(sitemap_body)
    # The `loc` elements in the sitemap are urls of the webpages
    Nokogiri(sitemap_body).css("loc")
  end
end
