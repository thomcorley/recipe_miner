# frozen_string_literal: true
require "rails_helper"

describe HttpRequest::Get do
  # TODO: use webmock to stub real requests

  describe "#get" do
    let(:url) { "www.nonsensewebaddress.com" }
    let(:request) { HttpRequest::Get.new(url: url) }
    let(:client) { HTTParty }
    let(:stubbed_response) { OpenStruct.new(code: 200, body: "Chocolate Cookies") }

    before { allow(client).to receive(:get).and_return(stubbed_response) }

    it "returns a status code of a response" do
      expect(request.code).to eq(200)
    end

    it "returns the body of a response" do
      expect(request.body).to eq("Chocolate Cookies")
    end
  end
end
