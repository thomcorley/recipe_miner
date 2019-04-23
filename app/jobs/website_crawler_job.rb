# frozen_string_literal: true

class WebsiteCrawlerJob < Struct.new(:website_url)
  def self.schedule(website_url)
    Delayed::Job.enqueue(
      new(website_url),
      priority: 0
    )
  end

  def perform
    logger = Delayed::Worker.logger

    logger.info(
      "#{Time.now}: [JOB] Crawling website for recipe data: #{website_url}"
    )

    runtime = Benchmark.realtime do
      WebsiteCrawler.new(url: website_url).crawl
    end

    formatted_runtime = sprintf("%.4f", runtime)
    logger.info(
      "#{Time.now}: [JOB] Finished crawling website (#{website_url}) after #{formatted_runtime}"
    )
  end
end
