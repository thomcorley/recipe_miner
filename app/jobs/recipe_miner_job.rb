class RecipeMinerJob < Struct.new(:miner)
	def self.schedule
		Delayed::Job.enqueue(
			new("Recipe Miner"),
			priority: 0
		)
	end

	def perform
		logger = Delayed::Worker.logger

		logger.info(
			"#{Time.now}: [JOB] Started mining for recipes"
		)

		runtime = Benchmark.realtime do 
			RecipeMiner.start_mining
		end

    formatted_runtime = sprintf("%.4f", runtime)
    logger.info(
      "#{Time.now}: [JOB] Finished mining for recipes after #{formatted_runtime}"
    )
  end
end