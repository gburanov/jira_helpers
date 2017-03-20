require_relative 'issue_analyser'
require 'byebug'

class NewSprintAnalyser
  attr_reader :issues
  attr_reader :client

  def initialize(client, issues)
    @issues = issues
    @client = client
    @pm_stories = 0
    @dev_stories = 0
    @dev_stories_bad = 0
  end

  def call(user = nil)
    issues.each do |issue|
      issue.fetch
      analyser = IssueAnalyser.new(client, issue)
      next if user.present? && user != analyser.assignee.name
      type = analyser.call2
      @pm_stories += 1 if type == 'pm'
      @dev_stories += 1 if type == 'dev'
      @dev_stories_bad += 1 if type == 'dev' && !analyser.errors.empty?
    end
    summary
  end

  private

  def summary
    puts "Pm stories #{@pm_stories}"
    puts "Dev stories #{@dev_stories}"
    puts "From the whole DEV stories - bad estimated #{@dev_stories_bad}"
  end
end
