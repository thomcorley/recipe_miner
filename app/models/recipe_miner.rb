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
	end
end