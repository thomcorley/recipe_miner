class WebpageCrawler
	def initialize(url)
		@url = url
	end

	def crawl
		recipe_page = HTTParty.get(@url)

		# Grab all the script elements in the page and loop through them
		script_elements = Nokogiri(recipe_page.body).css("script")

		# Putting this in a rescue block to handle the script elements
		# that can't be parsed as JSON
		script_elements.each do |script_element|
			begin
				content = JSON.parse(script_element.text)
			rescue
				content = nil	
			end

			next if content == nil

			# For a recipe schema this should be `application/ld+json`
			script_element_type = script_element.attributes["type"]&.value
			
			if content
				schema_type = content["@type"]
			else
				schema_type, schema_source = nil
			end

			schema_is_for_a_recipe = is_a_recipe_schema?(script_element_type, schema_source, schema_type)

			if schema_is_for_a_recipe && content
				parse_recipe_json(content)
			end
		end
	end

	# There are many schemas which have the same script tag
	# of `application/ld+json` but we only want the ones from 
	# schema.org and those of type "Recipe"
	def is_a_recipe_schema?(script_element, source, type)
		script_element == "application/ld+json" &&
		type == "Recipe"
	end

	# Parses the recipe json from the page
	# and saves it to the database
	def parse_recipe_json(json_content)
		recipe_hash = json_content.deep_symbolize_keys
		recipe = save_recipe(recipe_hash)

		save_ingredients(recipe_hash, recipe.id)
		save_instructions(recipe_hash, recipe.id)
	end

	# `recipe_hash` is the json content of the recipe
	# data, converted to a hash with symbols as keys
	def save_recipe(recipe_hash)
		recipe_keys = [:name, :image, :totalTime, :recipeYield, :description, :aggregateRating]
		raw_params = recipe_hash.select { |k,v| recipe_keys.include?(k) }
		formatted_recipe_params = sanitize_recipe_params(raw_params).merge(recipe_url: @url)

		Recipe.create!(formatted_recipe_params)
	end

	def save_ingredients(recipe_hash, recipe_id)
		ingredients_array = recipe_hash[:recipeIngredient]

		ingredients_array.each_with_index do |ingredient, index|
			position = index + 1
			Ingredient.create!(position: position, description: ingredient, recipe_id: recipe_id)
		end		
	end

	def save_instructions(recipe_hash, recipe_id)
		instructions_array = recipe_hash[:recipeInstructions]

		instructions_array.each_with_index do |instruction, index|
			position = index + 1
			Instruction.create!(position: position, description: instruction, recipe_id: recipe_id)
		end
	end

	def sanitize_recipe_params(raw_params)
		{
			title: raw_params[:name],
			image_url: raw_params[:image],
			total_time: raw_params[:totalTime],
			yield: raw_params[:recipeYield],
			description: raw_params[:description],
			rating_value: raw_params[:aggregateRating][:ratingValue],
			rating_count: raw_params[:aggregateRating][:ratingCount],
		}
	end
end