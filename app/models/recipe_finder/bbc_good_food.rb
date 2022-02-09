# frozen_string_literal: true

module RecipeFinder
  class BbcGoodFood
    attr_reader :nokogiri_webpage_body

    def initialize(url)
      @url = url
      @nokogiri_webpage_body = Nokogiri(webpage_body)
    end

    def recipe_hash
      title_element = @nokogiri_webpage_body.css("title")
      title = title_element.text.gsub(" recipe | BBC Good Food", "")

      {
        title: title,
        image_url: image_url,
        total_time: total_time,
        yield: recipe_yield,
        description: description,
        recipe_url: @url,
        ingredients: ingredients,
        instructions: instructions
      }
    end

    private

    def webpage_body
      webpage_body = HttpRequest::Get.new(@url).body
    end

    def total_time
      total_time = @nokogiri_webpage_body.xpath(xpaths[:total_time]).first.attributes["content"].value
    end

    def image_url
      image_section = @nokogiri_webpage_body.xpath(xpaths[:image_url])
      image_url = image_section.first.attributes["src"].value.prepend("https:")
    end

    def recipe_yield
      yield_element = @nokogiri_webpage_body.xpath(xpaths[:yield])
      yield_element.text.gsub(/\D/, "").to_i
    end

    def description
      description_element = @nokogiri_webpage_body.xpath(xpaths[:description]).first
      description_element.attributes["content"].value
    end

    def ingredients
      ingredients_element = @nokogiri_webpage_body.xpath(xpaths[:ingredients])
      ingredients_element.children.first.elements.map(&:text)
    end

    def instructions
      instructions_element = @nokogiri_webpage_body.xpath(xpaths[:instructions])
      instructions_element.children.map(&:text)
    end

    def xpaths
      {
        image_url: "//div[1]/div[1]/div[1]/div/div/div/img",
        total_time: "//div[1]/div[1]/div[2]/div[2]/div/meta[3]",
        yield: "//header/div[2]/div[2]/div/section[3]/span",
        description: "/html/head/meta[9]",
        ingredients: "//div/section[1]/div/div/div/div/div/div/ul",
        instructions: "//*[@id='recipe-method']/div/ol"
      }
    end

  end
end
