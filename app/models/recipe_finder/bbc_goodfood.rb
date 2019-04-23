# frozen_string_literal: true

module RecipeFinder
  class BBCGoodFood
    def initialize(url)
      @url = url
      @webpage_body = Nokogiri(webpage_body)
    end

    def recipe_hash
      title_element = @webpage_body.css("title")
      title = title_element.text.gsub(" recipe | BBC Good Food", "")

      {
        title: title,
        image_url: image_url,
        total_time: total_time,
        yield: recipe_yield,
        description: description,
        rating_value: rating_value,
        rating_count: rating_count,
        recipe_url: nil,
        ingredients: ingredients,
        instructions: instructions
      }
    end

    private

    def webpage_body
      webpage_body = HttpRequest::Get.new(@url).body
    end

    def total_time
      prep_time = @webpage_body.xpath(xpaths[:prep_time]).text.gsub(/\D/, "").to_i
      cook_time_hour = @webpage_body.xpath(xpaths[:cook_time_hour]).text.gsub(/\D/, "").to_i
      cook_time_minute = @webpage_body.xpath(xpaths[:cook_time_minute]).text.gsub(/\D/, "").to_i

      (prep_time*60) + (cook_time_hour*3600) + (cook_time_minute*60)
    end

    def image_url
      image_section = @webpage_body.xpath(xpaths[:image_url])
      image_url = image_section.first.attributes["src"].value.prepend("https:")
    end

    def recipe_yield
      yield_element = @webpage_body.xpath(xpaths[:yield])
      yield_element.text.gsub(/\D/, "").to_i
    end

    def description
      description_element = @webpage_body.xpath(xpaths[:description]).first
      description_element.attributes["content"].value
    end

    def rating_value
      rating_value_element = @webpage_body.xpath(xpaths[:rating_value])
      rating_value_element.first.attributes["content"].text.to_i
    end

    def rating_count
      rating_count_element = @webpage_body.xpath(xpaths[:rating_count])
      rating_count_element.first.attributes["content"].text.to_i
    end

    def ingredients
      ingredients_element = @webpage_body.xpath(xpaths[:ingredients])

      ingredients_element.children.first.elements.map do |e|
        e.attributes["content"].text
      end
    end

    def instructions
      instructions_element = @webpage_body.xpath(xpaths[:instructions])
      instructions_element.children.map(&:text)
    end

    def xpaths
      {
        image_url: "//header/div[1]/div/img",
        prep_time: "//header/div[2]/div[2]/div/section[1]/div/span[1]/span",
        cook_time_hour: "//header/div[2]/div[2]/div/section[1]/div/span[2]/span[1]",
        cook_time_minute: "//header/div[2]/div[2]/div/section[1]/div/span[2]/span[2]",
        yield: "//header/div[2]/div[2]/div/section[3]/span",
        description: "/html/head/meta[9]",
        rating_value: "//span/meta[1]",
        rating_count: "//span/meta[4]",
        ingredients: "//*[@id='recipe-ingredients']/div/div",
        instructions: "//*[@id='recipe-method']/div/ol"
      }
    end
  end
end
