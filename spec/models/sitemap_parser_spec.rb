# frozen_string_literal: true

RSpec.describe SitemapParser do
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
      sitemap_url = "https://www.grubdaily.com"
      allow_any_instance_of(HttpRequest::Get).to receive(:body).and_return(test_sitemap_xml)

      array_of_urls = SitemapParser.new(sitemap_url).array_of_urls

      expect(array_of_urls).to be_a(Array)
      expect(array_of_urls.empty?).to be(false)
      expect(array_of_urls.first).to match(URI::regexp)
    end
  end

    # rubocop:disable Layout/AlignHash, Layout/IndentHash
  def stub_response_for(url:, body:)
    stub_request(:get, url).
      with(
        headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'User-Agent'=>'Ruby'
        }
      ).
      to_return(status: 200, body: body, headers: {})
  end
end



# TODO: clean below

# nokogiri_link_objects = get_links_from_sitemap(sitemap_response.body)

# # Assuming that if there are less than 50 links in the sitemap
# # its a sitemap of sitemaps and we have to loop through each link
# if nokogiri_link_objects.count < 50
#   nokogiri_link_objects.each do |single_sitemap_object|
#     inner_sitemap = HTTParty.get(single_sitemap_object.text).body
#     inner_link_objects = get_links_from_sitemap(inner_sitemap)

#     inner_link_objects.each do |inner_link_object|
#       url_of_webpage = inner_link_object.text
#       WebpageCrawlerJob.schedule(url_of_webpage)
#     end
#   end
# else
#   nokogiri_link_objects.each do |link_object|
#     url_of_webpage = link_object.text
#     WebpageCrawlerJob.schedule(url_of_webpage)
#   end
# end
