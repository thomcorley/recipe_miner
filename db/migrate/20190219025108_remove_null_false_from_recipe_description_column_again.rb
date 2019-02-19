class RemoveNullFalseFromRecipeDescriptionColumnAgain < ActiveRecord::Migration[5.1]
  def change
  	def change
  		change_column_null :recipes, :description, true
  	end
  end
end
