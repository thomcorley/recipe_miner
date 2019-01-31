class WebsiteCrawlerJob < Struct.new(:website_url)
	def perform
		WebsiteCrawler.crawl(website_url)
	end
end