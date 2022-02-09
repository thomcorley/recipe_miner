# frozen_string_literal: true

RSpec.describe SitemapParser do
  include StubRequestSpecHelper

  let(:test_sitemap_xml) { File.open("spec/test_data/sitemap.xml", "r").read }

  context "when given an XML sitemap" do
    it "returns an array of urls" do
      array_of_urls = SitemapParser.new(test_sitemap_xml).array_of_urls

      expect(array_of_urls).to be_a(Array)
      expect(array_of_urls.empty?).to be(false)
      expect(array_of_urls.first).to match(URI::regexp)
    end
  end

  context "when given a sitemap url" do
    it "returns an array of urls" do
      allow_any_instance_of(HttpRequest::Get).to receive(:body).and_return(test_sitemap_xml)

      array_of_urls = SitemapParser.new(grubdaily_url).array_of_urls

      expect(array_of_urls).to be_a(Array)
      expect(array_of_urls.empty?).to be(false)
      expect(array_of_urls.first).to match(URI::regexp)
    end
  end

  context "when given a sitemap of sitemaps" do
    it "returns an array of URLs" do
      sitemap_of_sitemaps = File.read("spec/test_data/sitemap_of_sitemaps.xml")
      allow_any_instance_of(HttpRequest::Get).to receive(:body).and_return(sitemap_of_sitemaps)
      expect(Rails.logger).to receive(:info).with("Sitemap of sitemaps detected")

      array_of_urls = SitemapParser.new(grubdaily_url).array_of_urls
    end
  end
end
