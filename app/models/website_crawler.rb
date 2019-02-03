class WebsiteCrawler
	def initialize(url)
		@url = url
	end

	def crawl
		sitemap_request = HTTParty.get(construct_url_from(@url) + "/sitemap.xml")


		nokogiri_link_objects = get_links_from_sitemap(sitemap_request.body)

		# Assuming that if there are less than 50 links in the sitemap
		# its a sitemap of sitemaps and we have to loop through each link
		if nokogiri_link_objects.count < 50
			nokogiri_link_objects.each do |single_sitemap_object|
				inner_sitemap = HTTParty.get(single_sitemap_object.text).body
				inner_link_objects = get_links_from_sitemap(inner_sitemap)

				inner_link_objects.each do |inner_link_object|
					url_of_webpage = inner_link_object.text
					WebpageCrawlerJob.schedule(url_of_webpage)
				end
			end
		else
			nokogiri_link_objects.each do |link_object|
				url_of_webpage = link_object.text
				WebpageCrawlerJob.schedule(url_of_webpage)
			end
		end
	end

	# The url of the recipe website may have subdomains, query string params etc
	# so we want to extract only the plain url.
	def construct_url_from(full_web_address)
		uri = URI.parse(full_web_address.strip)
		uri.scheme + "://" + uri.host
	end

	# Takes the response `.body` from an HTTParty request to the sitemap  
	def get_links_from_sitemap(sitemap_body)
		# All of the `loc` elements in the sitemap are urls of the website's pages
		Nokogiri(sitemap_body).css("loc")
	end
end