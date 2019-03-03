class Recipe < ApplicationRecord
	AMP_REGEX = /\/amp([^a-zA-Z]|$|\s)/
	has_many :ingredients, dependent: :destroy
	has_many :instructions, dependent: :destroy

	validates_uniqueness_of :recipe_url 

	after_save :check_for_amp_version

	def check_for_amp_version
		last_recipe_url = Recipe.last.recipe_url

		last_url_stripped = last_recipe_url.gsub(AMP_REGEX, "")
		this_recipe_url_stripped = recipe_url.gsub(AMP_REGEX, "")

		# If the stripped version of the previous url is the same as this one,
		# delete the current recipe. If the stripped version of this url is the 
		# same as the previous one, delete the previous one

		self.destroy if last_url_stripped == recipe_url
		self.destroy if this_recipe_url_stripped == last_recipe_url
	end
end
