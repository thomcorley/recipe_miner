# frozen_string_literal: true

require "rails_helper"

describe Miner do
  include StubRequestSpecHelper

  describe "#start" do
    context "invoking the website crawler" do
      before do
        stub_200_response_for("https://www.bbcgoodfood.com/sitemap.xml")
        stub_200_response_for("https://www.grubdaily.com/sitemap.xml")
        allow(WebsiteCrawlerJob).to receive(:schedule).and_return(nil)
      end

      it "enqueues the website crawler job" do
        expect(WebsiteCrawlerJob).to receive(:schedule).with("https://www.grubdaily.com/")

        described_class.new("lib/test_website_directory.txt").start
      end

      it "uses the default if no directory is given" do
        expect(WebsiteCrawlerJob).to receive(:schedule).with("https://www.grubdaily.com/")

        described_class.new.start
      end
    end

    context "error handling" do
      let(:website_url) { "https://www.grubdaily.com/" }
      let(:sitemap_url) { website_url + "/sitemap.xml" }

      it "raises an error when it cannot find a sitemap" do
        stub_400_response_for("https://www.grubdaily.com/sitemap.xml")
        error_message = "[#{described_class}] Cannot find sitemap for #{website_url}"

        expect{ described_class.new.start }.to raise_error(Errors::SitemapNotFound, error_message)
      end

      it "raises an error when initialized with no directory" do
        stub_200_response_for("https://www.bbcgoodfood.com/sitemap.xml")
        error_message = "[#{described_class}] Website directory must be provided"

        expect{ described_class.new(nil) }.to raise_error(Errors::MissingDirectory, error_message)
      end
    end
  end
end
