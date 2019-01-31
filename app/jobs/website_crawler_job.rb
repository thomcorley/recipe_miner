class WebsiteCrawlerJob < Struct.new(:website_url)
	# TODO: move all of this to a new class and add unit test(s)
	def perform
		sitemap_request = HTTParty.get(construct_url_from(website_url) + "/sitemap.xml")

		recipe_collection = []

		# All of the `loc` elements in the sitemap are urls of the website's pages
		website_links = Nokogiri(sitemap_request.body).css("loc")

		website_links.each do |website_link|
			url = website_link.text
			recipe_page = HTTParty.get(url)

			# Grab all the script elements in the page and loop through them
			script_elements = Nokogiri(recipe_page.body).css("script")

			# Put this in a rescue block to handle the script elements
			# that can't be parsed as JSON
			script_elements.each do |script_element|
				begin
					content = JSON.parse(script_element.text)
				rescue
					content = nil	
				end

				# For a recipe schema this should be `application/ld+json`
				script_element_type = script_element.attributes["type"]&.value
				
				if content
					schema_source = content["@context"]
					schema_type = content["@type"]
				else
					schema_type, schema_source = nil
				end

				detect_recipe_schema = is_a_recipe_schema?(script_element_type, schema_source, schema_type)

				if detect_recipe_schema && content
					recipe_hash = content.deep_symbolize_keys
					keys = [:name, :image, :totalTime, :recipeYield, :description, :ratingValue, :ratingCount]

					recipe_params = recipe_hash.select { |k,v| keys.include?(k) }
					# TODO: grab the params to create ingredients and instructions
				end
			end
		end
	end
end