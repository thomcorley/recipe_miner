require "rails_helper"

RSpec.describe RecipeMinerJob, "#perform" do
	it "performs successfully" do
		expect(RecipeMiner).to receive(:start_mining)

		RecipeMinerJob.new.perform
	end
end
