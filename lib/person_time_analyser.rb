# frozen_string_literal: true
require_relative 'monkey_patching'
require_relative 'constants'
require_relative 'vacations'

class PersonTimeAnalyser
  attr_reader :sprint_start
  attr_reader :sprint_end
  attr_reader :vacations

  def initialize(sprint_start, vacations)
    @sprint_start = sprint_start
    @sprint_end = sprint_start + 13
    @vacations = vacations
  end

  def call
    puts "Today is #{current_day} of the sprint"
  end

  def total
    DEVUSERS.each do |user|
      puts "User #{user} has #{estimated_total(user)} hours"
    end
  end

  def current_day
    business_days_between(sprint_start, Time.now.utc.to_date).count
  end

  def estimated_until_today(author)
    estimated_for(author, Time.now.utc.to_date)
  end

  def estimated_total(author)
    estimated_for(author, sprint_end)
  end

  private

  def estimated_for(author, day)
    time_per_day = TEAM_LEADS.include?(author) ? 3 : 6
    days = business_days_between(sprint_start, day)
    days = vacations.filter(author, days)
    time_per_day * days.count
  end

  def business_days_between(date1, date2)
    business_days = []
    date = date2
    while date >= date1
      business_days << date unless date.saturday? || date.sunday?
      date -= 1
    end
    business_days
  end
end
