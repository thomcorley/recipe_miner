# frozen_string_literal: true

class SitemapParser
  def initialize(sitemap)
    @sitemap = sitemap
  end

  def array_of_urls
    if sitemap_is_url?
      # assuming that the sitemap is XML, not some other format (JSON?)
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

  # Assuming that if there are less than 50 links in the sitemap its a sitemap of sitemaps
  def is_a_sitemap_of_sitemaps?
    array_of_urls < 20
  end

  def parse_xml(xml)
    link_objects = Nokogiri(xml).css("loc")
    link_objects.map(&:text)
  end
end
