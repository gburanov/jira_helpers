# frozen_string_literal: true

class Integer
  def ago
    Time.zone.now - self
  end

  def day
    60 * 60 * 24
  end
end
