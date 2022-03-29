# frozen_string_literal: true
require "httparty"

class Miner
  WEBSITE_DIRECTORY = "lib/website_directory.txt"

  def initialize(website_directory = WEBSITE_DIRECTORY)
    @website_directory = website_directory
    ensure_presence_of_directory
  end

  def start
    array_of_website_urls.each do |website_url|
      verify_sitemap(website_url)

      WebsiteCrawlerJob.schedule(website_url)
    end
  end

  private

  attr_reader :website_directory

  def verify_sitemap(website_url)
    sitemap_request = HTTParty.get(extract_url_from(website_url) + "/sitemap.xml")
    code = sitemap_request.code

    raise Errors::SitemapNotFound.new(self.class, website_url) unless code == 200
  end

  # The url of the recipe website may have subdomains, query
  # string params etc which we want to remove.
  def extract_url_from(full_web_address)
    uri = URI.parse(full_web_address.strip)
    uri.scheme + "://" + uri.host
  end

  def array_of_website_urls
    File.read(website_directory).split("\n")
  end

  def ensure_presence_of_directory
    raise Errors::MissingDirectory.new(self.class) unless website_directory
  end
end
