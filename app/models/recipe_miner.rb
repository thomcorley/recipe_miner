class RecipeMiner
	class << self
		require "httparty"

		WEBSITE_LIST = "lib/website_directory.txt"

		def start_mining
			recipe_websites = File.open(WEBSITE_LIST, "r")

			url_list = []

			recipe_websites.each do |line|
				url_list << line
			end

	  	# Looping through the list of recipe websites
	  	url_list.each do |site|
	  		next unless has_sitemap?(site)
	  		crawl_website(site)
			end
		end

		def crawl_website(site)
			sitemap_request = HTTParty.get(construct_url_from(site) + "/sitemap.xml")

			recipe_collection = []

			# All of the `loc` elements in the sitemap are urls of the website's pages
			website_links = Nokogiri(sitemap_request.body).css("loc")

			website_links.first(10).each do |website_link|
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
						# TODO: substitute this section for code to parse the JSON and save recipe to database

						# EG:
						# WebsiteCrawlerJob.new.schedule
						recipe_collection << content
						puts "Added #{content["name"]} to collection!"
					end
				end

				puts recipe_collection.count
			end
		end

		def has_sitemap?(website_url)
			sitemap_request = HTTParty.get(construct_url_from(website_url) + "/sitemap.xml")
			sitemap_request.code == 200 ? true : false
		end

		# There are many schemas which have the same script tag
		# of `application/ld+json` but we only want the ones from 
		# schema.org and those of type "Recipe"
		def is_a_recipe_schema?(script_element, source, type)
			script_element == "application/ld+json" &&
			source == "http://schema.org" &&
			type == "Recipe"
		end

		# The url of the recipe website may have subdomains, query string params etc
		# so we want to extract only the plain url.
		def construct_url_from(full_web_address)
			uri = URI.parse(full_web_address)
			uri.scheme + "://" + uri.host
		end
	end
end