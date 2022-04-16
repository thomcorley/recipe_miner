# frozen_string_literal: true
class RecipeRepository
  class << self
    def sample(count)
      Recipe.order(Arel.sql("RANDOM()")).limit(count)
    end

    def with_term_in_title(term)
      recipes.where("LOWER(recipes.title) LIKE ?", "%#{term}%")
    end

    def with_term_in_ingredients(term)
      recipes.where("LOWER(ingredients.description) LIKE ?", "%#{term}%")
    end

    def with_term_in_introducion(term)
      recipes.where("LOWER(recipes.description) LIKE ?", "%#{term}%")
    end

    def recipes_containing_ingredients(ingredients)
      Queries::RecipeWithIngredients.new(ingredients: ingredients).result
    end

    def recipes
      @recipes ||= Recipe.distinct.joins(:ingredients)
    end
  end

  private_class_method :recipes
end
