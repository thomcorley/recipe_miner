# frozen_string_literal: true

FactoryBot.define do
  factory :recipe do
    title { "Onion Soup" }
    image_url { "https://www.grubdaily.com/onion-soup-#{random_string}.jpg" }
    total_time { "PT4H" }
    rating_value { 5 }
    rating_count { 60 }
    description { "A french classic" }
    recipe_url { "https://www.grubdaily.com/onion-soup-#{random_string}" }
  end
end

def random_string
  SecureRandom.alphanumeric(10)
end
