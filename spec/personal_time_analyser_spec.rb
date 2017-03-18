# frozen_string_literal: true
require 'timecop'

require_relative '../person_time_analyser'

describe PersonTimeAnalyser do
  let(:start_date) { Date.parse('08.03.2017') }
  subject { described_class.new(start_date) }

  it 'show correctly day of sprint' do
    Timecop.freeze('18.03.2017') do
      subject.current_day
    end
  end
end
