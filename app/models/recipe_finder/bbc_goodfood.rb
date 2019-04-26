# frozen_string_literal: true

module RecipeFinder
  class BBCGoodFood
    def initialize(url)
      @url = url
    end

    def recipe_hash
      title_element = Nokogiri(webpage_body).css("title")
      title = title_element.text.gsub(" recipe | BBC Good Food", "")

      {
        title: title,
        image_url: image_url,
        total_time: total_time,
        yield: nil,
        description: nil,
        rating_value: nil,
        rating_count: nil,
        recipe_url: nil,
        ingredients: nil,
        instructions: nil
      }
    end

    private

    def webpage_body
      webpage_body = HttpRequest::Get.new(@url).body
    end

    def total_time
      prep_time = Nokogiri(webpage_body).xpath(xpaths[:prep_time]).text.gsub(/\D/, "").to_i
      cook_time_hour = Nokogiri(webpage_body).xpath(xpaths[:cook_time_hour]).text.gsub(/\D/, "").to_i
      cook_time_minute = Nokogiri(webpage_body).xpath(xpaths[:cook_time_minute]).text.gsub(/\D/, "").to_i

      (prep_time*60) + (cook_time_hour*3600) + (cook_time_minute*60)
    end

    def image_url
      image_section = Nokogiri(webpage_body).xpath(xpaths[:image_url])
      image_url = image_section.first.attributes["src"].value
      image_url = image_url.prepend("https:")
    end

    def xpaths
      {
        prep_time: "//header/div[2]/div[2]/div/section[1]/div/span[1]/span",
        cook_time_hour: "//header/div[2]/div[2]/div/section[1]/div/span[2]/span[1]",
        cook_time_minute: "//header/div[2]/div[2]/div/section[1]/div/span[2]/span[2]",
        image_url: "//header/div[1]/div/img"
      }
    end
  end
end
