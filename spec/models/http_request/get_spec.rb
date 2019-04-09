# frozen_string_literal: true

describe HttpRequest::Get do

  # TODO: change this spec so it's not testing the class under test

  describe "#get" do
    let(:url) { "www.nonsensewebaddress.com" }

    it "returns a status code of a response" do
      request = HttpRequest::Get.new(url)
      allow_any_instance_of(HttpRequest::Get).to receive(:code).and_return(200)

      expect(request.code).to eq 200
    end

    it "returns the body of a response" do
      request = HttpRequest::Get.new(url)
      allow_any_instance_of(HttpRequest::Get).to receive(:body).and_return("Hello World")

      expect(request.body).to eq "Hello World"
    end
  end
end
