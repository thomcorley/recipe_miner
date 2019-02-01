class WebpageCrawlerJob < Struct.new(:webpage_url)
	def self.schedule(webpage_url)
		Delayed::Job.enqueue(
			new(webpage_url),
			priority: 0
		)
	end

	def perform
		logger = Delayed::Worker.logger

		logger.info(
			"#{Time.now}: [JOB] Crawling page for recipe data: #{webpage_url}"
		)

		runtime = Benchmark.realtime do 
			WebpageCrawler.new(webpage_url).crawl
		end

    formatted_runtime = sprintf("%.4f", runtime)
    logger.info(
      "#{Time.now}: [JOB] Finished crawling page (#{webpage_url}) after #{formatted_runtime}"
    )
  end
end