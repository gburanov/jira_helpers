require_relative 'constants'

class IssueAnalyser
  attr_reader :issue
  attr_reader :client

  def initialize(client, issue)
    @issue = issue
    @client = client
    @errors = []
  end

  def call
    key = issue.key
    return if filter_issue?
    subtasks_total = []
    subtasks_noestimation = []
    subtasks = JIRA::Resource::Issue.jql(client, "parent = #{key}")
    subtasks.each do |subtask|
      assignee = subtask.assignee.name
      unless POSSIBLE_USERS.include?(assignee)
        @errors << "Strange subtask #{subtask.key} assignee #{assignee}"
      end
      next unless FT2USERS.include?(assignee)
      subtasks_total << subtask
      total_time = subtask.aggregatetimeoriginalestimate
      subtasks_noestimation << subtask if total_time.nil? || total_time.zero?
    end
    if subtasks_total.count == 0
      @errors << "Total number of subtasks #{subtasks_total.count}"
    end
    subtasks_noestimation.each do |subtask|
      @errors << "Unestimated subtask #{subtask.key}"
    end
    print_errors
  end

  def print_errors
    return if @errors.empty?
    puts "#{issue.key} - #{issue.summary} - for #{issue.assignee.name}"
    @errors.each do |error|
      puts error
    end
    puts ''
  end

  def filter_issue?
    issue.summary.downcase.include?('plan') && issue.summary.downcase.include?('sprint')
  end

  def filter_subtask?
  end
end
