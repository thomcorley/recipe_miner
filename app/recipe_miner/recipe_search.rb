# frozen_string_literal: true
class RecipeSearch
  def initialize(query:, repository: RecipeRepository)
    @repository = repository
    set_ingredients(query)
  end

  def result
    if ingredients.none?
      repository.sample(10)
    elsif ingredients.count == 1
      recipes_containing_term(ingredients.first).uniq.first(10)
    else
      repository.recipes_containing_ingredients(ingredients).first(10)
    end
  end

  private

  attr_reader :ingredients, :repository

  def set_ingredients(query)
    @ingredients = query.downcase.delete(" ","").split(" ")
  end

  def recipes_containing_term(term)
    repository.with_term_in_title(term) +
      repository.with_term_in_ingredients(term) +
      repository.with_term_in_introducion(term)
  end
end
