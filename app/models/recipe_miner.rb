# frozen_string_literal: true

class RecipeMiner
  class << self
    require "httparty"

    WEBSITE_LIST = "lib/website_directory.txt"

    def start_mining(website_list = WEBSITE_LIST)
      recipe_websites = File.open(website_list, "r")

      url_list = []

      recipe_websites.each do |line|
        url_list << line
      end

      # Looping through the list of recipe websites
      url_list.each do |website_url|
        next unless has_sitemap?(website_url)

        WebsiteCrawlerJob.schedule(website_url)
      end
    end

    def has_sitemap?(website_url)
      sitemap_request = HTTParty.get(construct_url_from(website_url) + "/sitemap.xml")
      sitemap_request.code == 200
    end

    # The url of the recipe website may have subdomains, query string params etc
    # so we want to extract only the plain url.
    def construct_url_from(full_web_address)
      uri = URI.parse(full_web_address.strip)
      uri.scheme + "://" + uri.host
    end
  end
end
