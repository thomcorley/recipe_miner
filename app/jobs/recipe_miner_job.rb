# frozen_string_literal: true

class RecipeMinerJob < Struct.new(:directory)
  def self.schedule
    Delayed::Job.enqueue(
      new("lib/website_directory.txt"),
      priority: 0
    )
  end

  def perform
    logger = Delayed::Worker.logger

    logger.info(
      "#{Time.now}: [JOB] Started mining for recipes"
    )

    runtime = Benchmark.realtime do
      RecipeMiner.new(directory: directory).start_crawling_websites
    end

    formatted_runtime = sprintf("%.4f", runtime)
    logger.info(
      "#{Time.now}: [JOB] Finished mining for recipes after #{formatted_runtime}"
    )
  end
end
