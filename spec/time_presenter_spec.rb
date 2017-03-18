# frozen_string_literal: true
require_relative 'spec_helper'
require_relative '../lib/time_presenter'

describe TimePresenter do
  subject { described_class.new(time) }

  context 'when it is 23 hours' do
    let(:time) { 23 }

    it 'show correct' do
      expect(subject.call).to eq '2.9 days(23 hours)'
    end
  end
end
