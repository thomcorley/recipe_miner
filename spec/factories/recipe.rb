# frozen_string_literal: true

FactoryBot.define do
  factory :recipe do
    title { "Lamb Bolognese" }
    image_url { "https://s3.eu-west-2.amazonaws.com/grubdaily/lamb_bolognese.jpg" }
    total_time { "PT3H" }
    description { "Bolognese made with lamb mince instead of beef is much more flavoursome." }
    recipe_url { "https://www.grubdaily.com/lamb-bolognese" }
  end
end
