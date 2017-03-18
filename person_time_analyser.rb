# frozen_string_literal: true
class PersonTimeAnalyser
  attr_reader :sprint_start

  def initialize(sprint_start)
    @sprint_start = sprint_start
  end

  def call
    puts "Today is #{current_day} of the sprint"
  end

  def current_day
    business_days_between(sprint_start, DateTime.current.to_date)
  end

  def estimated_for(author)
    time_per_day = TEAM_LEADS.include?(author) ? 5 : 3
    time_per_day * current_day
  end

  private

  def business_days_between(date1, date2)
    business_days = 0
    date = date2
    byebug
    while date > date1
      business_days += 1 unless date.saturday? || date.sunday?
      date -= 1.day
    end
    business_days
  end
end
