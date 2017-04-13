# frozen_string_literal: true
class Iterator
  attr_reader :array

  def initialize(array)
    @array = array
  end

  def each
    i = 0
    while i < array.length
      puts "#{i}/#{count}"
      yield array[i]
      i += 1
    end
  end

  def count
    array.count
  end
end
