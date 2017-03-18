# frozen_string_literal: true
class TimePresenter
  attr_reader :hours

  def initialize(hours)
    @hours = hours
  end

  def call
    "#{(hours.to_f / 8).round(1)} days(#{hours} hours)"
  end
end
