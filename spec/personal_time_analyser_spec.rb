# frozen_string_literal: true
require 'timecop'
require 'byebug'

require_relative '../person_time_analyser'

describe PersonTimeAnalyser do
  let(:start_date) { Date.parse('08.03.2017') }
  subject { described_class.new(start_date) }

  it 'show correctly day of sprint' do
    Timecop.freeze('18.03.2017') do
      expect(subject.current_day).to be 8
    end
  end

  it 'show time for team lead' do
    Timecop.freeze('18.03.2017') do
      expect(subject.estimated_for('georgy.buranov')).to be 24
    end
  end

  it 'show time for developer' do
    Timecop.freeze('18.03.2017') do
      expect(subject.estimated_for('khaled.gomaa')).to be 48
    end
  end
end
