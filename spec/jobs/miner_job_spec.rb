# frozen_string_literal: true

require "rails_helper"

RSpec.describe MinerJob, "#perform" do
  let(:test_website_directory) { "lib/test_website_directory.txt" }

  it "performs successfully" do
    expect_any_instance_of(Miner).to receive(:start)
    MinerJob.new(test_website_directory).perform
  end
end
