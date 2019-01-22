class HomeController < ApplicationController
  require "httparty"

  def index
  	website_directory = File.open("lib/website_directory.txt", "r")

  	url_list = []
  	urls_with_sitemap = []

  	website_directory.each do |line|
  		url_list << line
  	end

  	# Looping through the list of recipe websites
  	recipe_websites.each do |site|
			uri = URI.parse(site)
			base_url = uri.scheme + "://" + uri.host
			sitemap = HTTParty.get(base_url + "/sitemap.xml")

			if sitemap.code == 200 
				puts "Sitemap exists for #{uri.host}"
			end

			recipe_collection = []

			# All of the `loc` elements in the sitemap
			website_links = Nokogiri(sitemap.body).css("loc")

			website_links.first(10).each do |website_link|
				url = website_link.text
				recipe_page = HTTParty.get(url)

				# Grab all the script elements in the page and loop through them
				script_elements = Nokogiri(recipe_page.body).css("script")

				script_elements.each do |script_element|
					begin
						content = JSON.parse(script_element.text)
					rescue
						content = nil	
					end

					script_element_type = script_element.attributes["type"]&.value
					
					if content
						schema_source = content["@context"]
						schema_type = content["@type"]
					else
						schema_type, schema_source = nil
					end

					is_recipe_schema = script_element_type == "application/ld+json" &&
														 schema_source == "http://schema.org" &&
														 schema_type == "Recipe"

					if is_recipe_schema && content
						recipe_collection << content
						puts "Added #{content["name"]} to collection!"
					end
				end

				puts recipe_collection.inspect
			end
  	end
  end
end
