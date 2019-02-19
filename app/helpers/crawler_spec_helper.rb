module CrawlerSpecHelper
	def read_test_file(path_to_file)
		File.open(path_to_file, "r").read	 	
	end
end