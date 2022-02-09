# frozen_string_literal: true
# rubocop:disable Metrics/CyclomaticComplexity

class Recipe < ApplicationRecord
  AMP_REGEX = %r(\/amp([^a-zA-Z]|$|\s))
  ISO_TIME_REGEX = /P((?<days>\d)+D)?T?((?<hours>\d+)H)?((?<minutes>\d+)M)?((?<seconds>\d+)S)?/

  has_many :ingredients, dependent: :destroy
  has_many :instructions, dependent: :destroy

  validates_uniqueness_of :recipe_url
  validates_format_of :total_time, :with => ISO_TIME_REGEX

  before_save :deduplicate_recipes_with_amp_versions

  FULL_ATTRIBUTES = [
    :title,
    :image_url,
    :total_time,
    :yield,
    :description,
    :rating_value,
    :rating_count,
    :recipe_url,
    :ingredients,
    :instructions
  ]

  class AmpRecipeDetectedError < StandardError
    def message
      "Alternative AMP recipe detected, destroying self in favour of it"
    end
  end

  def display_title
    if title.length < 28
      title
    else
      title.first(28) + "..."
    end
  end

  def ingredients_summary
    summary = ingredients.map(&:description).join(" - ").first(145)

    summary.length < 145 ? summary : summary + "..."
  end

  def human_readable_time
    return unless total_time

    match_data = ISO_TIME_REGEX.match(total_time)


    @days = match_data.named_captures["days"].to_i
    @hours = match_data.named_captures["hours"].to_i
    @minutes = match_data.named_captures["minutes"].to_i

    if only_days?
      "#{days}" + " day".pluralize(days)
    elsif only_hours?
      "#{hours}" + " hr".pluralize(hours)
    elsif hours_and_minutes?
      "#{hours}" + " hr".pluralize(hours) + " #{minutes}" + " min"
    elsif only_minutes?
      "#{minutes}" + " min"
    end
  end


  private

  attr_reader :days, :hours, :minutes

  def only_days?
    days > 0 && hours == 0 && minutes == 0
  end

  def only_hours?
    hours > 0 && days == 0 && minutes == 0
  end

  def only_minutes?
    minutes > 0 && days == 0 && hours == 0
  end

  def hours_and_minutes?
    minutes > 0 && hours > 0 && days == 0
  end

  def deduplicate_recipes_with_amp_versions
    if is_amp?
      recipes = duplicate_recipes

      if recipes.any?
        recipes.each(&:destroy)
        Rails.logger.info("Other non-amp recipe(s) detected; removing")
      end
    else
      recipes = duplicate_amp_recipes

      if recipes.any?
        destroy
        raise AmpRecipeDetectedError
      end
    end
  end

  # Assuming that another recipe with the same title from the same website is the same recipe
  def duplicate_amp_recipes
    base_url = URI.parse(recipe_url).host
    Recipe.where(title: title).where("recipe_url LIKE '%#{base_url}%'").where("recipe_url LIKE '%/amp%'")
  end

  def duplicate_recipes
    stripped_url = recipe_url.gsub(AMP_REGEX, "/").chomp("/")
    Recipe.where(title: title).where("recipe_url LIKE '%#{stripped_url}%'")
  end

  def is_amp?
    recipe_url.match?(AMP_REGEX)
  end
end
# rubocop:enable Metrics/CyclomaticComplexity
