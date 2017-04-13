# frozen_string_literal: true
require 'byebug'
require_relative 'constants'

class ChangelogAnalyzer
  attr_reader :issue
  attr_reader :client

  def initialize(client, issue)
    @issue = issue
    @client = client
  end

  def moved_to_done?
    history.select do |h_element|
      h_element['created'].to_date > START_DATE && filter_items(h_element['items']).count.positive?
    end.count.positive?
  end

  private

  def filter_items(items)
    items.select do |item|
      item['field'] == 'status' && valid_statuses.include?(item['toString'])
    end
  end

  def valid_statuses
    %w(QA Done)
  end

  def history
    full_issue = client.Issue.find(issue.key, expand: 'changelog')
    full_issue.changelog['histories']
  end
end
