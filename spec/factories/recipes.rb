FactoryBot.define do
  factory :recipe do
		title { "Classic Omelette" }
		image_url { "https://www.grubdaily.com/classic-omelette.jpg" }
		total_time { "PT10M" }
		description { "One of my favourite easy meals" }
		recipe_url { "https://www.grubdaily.com/classic-omelette" } 
  end
end
