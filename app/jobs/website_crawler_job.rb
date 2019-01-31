class WebsiteCrawlerJob < Struct.new(:website_url)
	def perform
		WebsiteCrawler.new.(website_url).crawl
	end
end