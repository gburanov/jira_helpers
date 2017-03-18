# frozen_string_literal: true
class TimePresenter
  attr_reader :hours

  def initialize(hours)
    @hours = hours
  end

  def call
    "#{hours / 8}days - #{hours}hours"
  end
end
