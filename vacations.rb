# frozen_string_literal: true
class Vacations
  def initialize
    @days = {}
  end

  def add(author, from, to = nil)
    to = from if to.nil?
    from = Date.parse(from)
    to = Date.parse(to)
    (from..to).each do |date|
      @days[date] = {} if @days[date].nil?
      @days[date][author] = true
    end
  end

  def filter(author, days)
    days.reject do |date|
      @days.dig(date, author) == true
    end
  end
end
