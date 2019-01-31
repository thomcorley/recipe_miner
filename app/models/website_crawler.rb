class WebsiteCrawler
	def initialize(url)
		@url = url
	end

	def crawl
		sitemap_request = HTTParty.get(construct_url_from(@url) + "/sitemap.xml")

		nokogiri_link_objects = get_links_from_sitemap(sitemap_request.body)

		nokogiri_link_objects.each do |link_object|
			url_of_webpage = link_object.text
			WebpageCrawler.new(url_of_webpage).crawl
		end
	end

	def has_sitemap?
		sitemap_request = HTTParty.get(construct_url_from(@url) + "/sitemap.xml")
		sitemap_request.code == 200 ? true : false
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