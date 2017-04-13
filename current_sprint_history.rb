# frozen_string_literal: true
require_relative 'lib/client.rb'
require_relative 'lib/changelog_analyser.rb'
require_relative 'lib/issue_analyser.rb'
require_relative 'lib/iterator.rb'
require 'byebug'

client = default_client

filter = client.Filter.find('26700')
issues = JIRA::Resource::Issue.jql(client, filter.jql, start_at: nil, max_results: 1000)

Iterator.new(issues).each do |issue|
  if ChangelogAnalyzer.new(client, issue).moved_to_done?
    puts IssuePresenter.new(issue).full
  end
end
