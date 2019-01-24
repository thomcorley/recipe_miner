require 'rails_helper'

RSpec.describe RecipeMiner, type: :model do
  
  describe "#has_sitemap?" do
  	let(:website_with_map) { "https://www.grubdaily.com" }
  	let(:website_with_no_map) { "https://www.allrecipes.com" }
  	
  	it "detects a website that has a sitemap" do  	
	  	expect(RecipeMiner.has_sitemap?(website_with_map)).to be true
	  	expect(RecipeMiner.has_sitemap?(website_with_no_map)).to be false
	  end
  end

  describe "#is_a_recipe_schema" do  	
  	it "returns true for a valid recipe schema" do  	
  		is_schema = RecipeMiner.is_a_recipe_schema("application/ld+json", "http://schema.org", "Recipe")

  		expect(is_schema).to be true
	  end

  	it "returns false for a schema of a different type" do  	
  		is_schema = RecipeMiner.is_a_recipe_schema("application/ld+json", "http://schema.org", "Horse")

  		expect(is_schema).to be false	
	  end	  
  end
end
