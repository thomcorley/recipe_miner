# frozen_string_literal: true

class Miner
  require "httparty"

  def initialize(args = {})
    args = defaults.merge(args)
    @website_directory = args[:directory]
  end

  def start
    array_of_website_urls.each do |website_url|
      verify_sitemap(website_url)

      WebsiteCrawlerJob.schedule(website_url)
    end
  end

  private

  def verify_sitemap(website_url)
    sitemap_request = HTTParty.get(extract_url_from(website_url) + "/sitemap.xml")
    code = sitemap_request.code

    raise "[#{self.class}] Error: cannot find sitemap for #{website_url}" unless code == 200
  end

  # The url of the recipe website may have subdomains, query
  # string params etc which we want to remove.
  def extract_url_from(full_web_address)
    uri = URI.parse(full_web_address.strip)
    uri.scheme + "://" + uri.host
  end

  def array_of_website_urls
    raise "Miner: website directory must be provided" unless @website_directory

    File.read(@website_directory).split("\n")
  end

  def defaults
    { directory: "lib/website_directory.txt" }
  end
end
