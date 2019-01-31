class RecipeMiner
	class << self
		require "httparty"

		WEBSITE_LIST = "lib/website_directory.txt"

		def start_mining
			recipe_websites = File.open(WEBSITE_LIST, "r")

			url_list = []

			recipe_websites.each do |line|
				url_list << line
			end

	  	# Looping through the list of recipe websites
	  	url_list.each do |website_url|
	  		next unless has_sitemap?(website_url)
	  		
	  		Delayed::Job.enqueue WebsiteCrawlerJob.new(website_url)	
			end
		end

		def has_sitemap?(website_url)
			sitemap_request = HTTParty.get(construct_url_from(website_url) + "/sitemap.xml")
			sitemap_request.code == 200 ? true : false
		end

		# There are many schemas which have the same script tag
		# of `application/ld+json` but we only want the ones from 
		# schema.org and those of type "Recipe"
		def is_a_recipe_schema?(script_element, source, type)
			script_element == "application/ld+json" &&
			source == "http://schema.org" &&
			type == "Recipe"
		end

		# The url of the recipe website may have subdomains, query string params etc
		# so we want to extract only the plain url.
		def construct_url_from(full_web_address)
			uri = URI.parse(full_web_address.strip)
			uri.scheme + "://" + uri.host
		end
	end
end