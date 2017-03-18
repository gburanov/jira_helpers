# frozen_string_literal: true
require_relative 'monkey_patching'
require_relative 'constants'

class PersonTimeAnalyser
  attr_reader :sprint_start
  attr_reader :sprint_end
  attr_reader :vacations

  def initialize(sprint_start, vacations)
    @sprint_start = sprint_start
    @sprint_end = sprint_start + 14
    @vacations = vacations
  end

  def call
    puts "Today is #{current_day} of the sprint"
  end

  def current_day
    business_days_between(sprint_start, Time.now.utc.to_date)
  end

  def estimated_for_today(author)
    estimated_for(author, Time.now.utc.to_date)
  end

  def estimated_for_total(author)
    estimated_for(author, sprint_end)
  end

  private

  def estimated_for(author, day)
    time_per_day = TEAM_LEADS.include?(author) ? 3 : 6
    time_per_day * current_day
  end

  def business_days_between(date1, date2)
    business_days = 0
    date = date2
    while date >= date1
      business_days += 1 unless date.saturday? || date.sunday?
      date -= 1
    end
    business_days
  end
end
