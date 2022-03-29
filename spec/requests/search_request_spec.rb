# frozen_string_literal: true
require "rails_helper"

RSpec.describe "Search request" do
  describe "GET #search" do
    before { get "/search.json", params: { query: "carrots" } }

    it "returns HTTP success" do
      expect(response).to have_http_status(:success)
    end
  end
end
