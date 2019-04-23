# frozen_string_literal: true

class SitemapParser
  def initialize(sitemap)
    @sitemap = sitemap
    @logger = Rails.logger
  end

  def array_of_urls
    if sitemap_is_url?
      xml = HttpRequest::Get.new(@sitemap).body
      parse_xml(xml)
    else
      parse_xml(@sitemap)
    end
  end

  private

  def sitemap_is_url?
    @sitemap =~ URI::regexp && !(@sitemap =~ /\n/)
  end

  def parse_xml(xml)
    sitemap_link_objects = Nokogiri(xml).css("loc")

    if is_a_sitemap_of_sitemaps?(sitemap_link_objects)
      @logger.info("Sitemap of sitemaps detected")

      urls = []

      sitemap_link_objects.each do |obj|
        xml_of_urls = HttpRequest::Get.new(obj.text).body
        urls << Nokogiri(xml).css("loc").map(&:text)
      end

      urls.flatten
    else
      sitemap_link_objects.map(&:text)
    end
  end

  def is_a_sitemap_of_sitemaps?(sitemap_urls)
    sitemap_urls.count < 20
  end
end
