require 'rails_helper'

RSpec.describe WebpageCrawler, type: :model do
	setup do
		@crawler = WebpageCrawler.new("https://www.grubdaily.com/cavolo-nero-parmesan-salad")
		@recipe_json = {"@context":"http://schema.org","@type":"Recipe","name":"Cavolo Nero and Parmesan Salad","author":"Tom","image":"https://s3.eu-west-2.amazonaws.com/grubdaily/cavolo-nero-parmesan-salad.jpg","datePublished":"2019-01-27","totalTime":"PT40M","recipeYield":2,"description":"This is my favourite winter salad. It's amazingly savoury and in preparing the kale in 3 separate ways, there's a lovely texture contrast.","aggregateRating":{"ratingValue":4,"ratingCount":53},"recipeIngredient":["vegetable oil, for frying","sea salt and freshly cracked black pepper","2 teaspoons tarragon vinegar","3 tablespoons extra virgin olive oil","1 stick celery, peeled","1 handful pistachio nuts","1 handful cashew nuts","1 handful pine nuts","1 clove of garlic, peeled and finely sliced","30g parmesan cheese, finely grated","200g cavolo nero"],"recipeInstructions":["Heat the oven to 180C and place a roasting tray inside to get hot. Remove and discard the tough inner stalks from the cavolo nero, then roughly chop the leaves into 2-3 inch long pieces. Once the roasting tray is hot, place one third of the cavolo nero in the tray and toss with 1 tablespoon of the olive oil. Season lightly with sea salt and place in the oven for 10 minutes.","Put the steamed cavolo nero in a mixing bowl and allow to cool. Roughly chop the cashews and pistachios to be about the same size at the pine nuts, then place in a pan over a medium-high heat and add a small pinch of salt. Dry roast until lightly golden, then add to the mixing bowl. Finely slice the celery at an angle and add to the bowl along with the raw cavolo nero you set aside earlier. Add most of the parmesan, saving about a quarter of it to put on top at the end. Add 2 tablespoons of olive oil and the tarragon vinegar, then mix everything together. Taste and season with salt and pepper if necessary. It might need more olive oil and/or vinegar, too. Serve in a bowl, with the crisp cavolo nero and the reserved parmesan on the top.","Check the cavolo nero in the oven. You want it to be crisp. If it's not quite there then give it a toss and return to the oven for 5 minutes. When it's done, remove from the tray and place on a plate lined with kitchen paper to drain.","Take a frying pan or saute pan and place it over a medium heat. Add a little vegetable oil and, once it's hot, add the remaining cavolo nero and season lightly with sea salt. Stir and fry for 30 seconds, then add the sliced garlic. Continue to fry for 30 more seconds then add a glassful of water. Cover with a lid or some kitchen foil and steam until the cavolo nero is tender.","From the remainder of the cavolo nero, take a small handful and finely chop. Set this aside - it will go in the salad, raw, at the end."]}
		@recipe_hash = @recipe_json.deep_symbolize_keys
	end

  describe "#parse_recipe_json" do  	
  	it "saves a recipe" do  		
  		count_before = Recipe.all.count
  		@crawler.parse_recipe_json(@recipe_json)
  		count_after = Recipe.all.count

  		expect(count_after - count_before).to eq(1)
	  end
  end

  describe "#save_recipe" do
	  it "has the correct recipe url" do
	  	recipe = @crawler.save_recipe(@recipe_hash)	
	  	correct_url = "https://www.grubdaily.com/cavolo-nero-parmesan-salad"

	  	expect(recipe.recipe_url).to eq(correct_url)
	  end
  end

  describe "#is_a_recipe_schema" do  	
  	it "returns true for a valid recipe schema" do  	
  		is_schema = @crawler.is_a_recipe_schema?("application/ld+json", "http://schema.org", "Recipe")

  		expect(is_schema).to be true
	  end

  	it "returns false for a schema of a different type" do  	
  		is_schema = @crawler.is_a_recipe_schema?("application/ld+json", "http://schema.org", "Horse")

  		expect(is_schema).to be false	
	  end	  
  end  
end
