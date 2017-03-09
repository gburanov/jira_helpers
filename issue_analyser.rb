require_relative 'constants'

class IssueAnalyser
  attr_reader :issue
  attr_reader :client
  attr_reader :errors

  def initialize(client, issue)
    @issue = issue
    @client = client
    @errors = []
  end

  def type
    return 'dev' if DEVUSERS.include?(issue.assignee.name)
    return 'pm' if PMUSERS.include?(issue.assignee.name)
    return 'qa' if QAUSERS.include?(issue.assignee.name)
    'unknown'
  end

  def call2
    return if filter_issue?
    dump if type == 'unknown'
    call if type == 'dev'
    type
  end

  def call
    key = issue.key
    return if filter_issue?
    subtasks_total = []
    subtasks_noestimation = []
    subtasks = JIRA::Resource::Issue.jql(client, "parent = #{key}")
    has_qa = issue.summary.downcase.include?('no qa')
    subtasks.each do |subtask|
      assignee = subtask.assignee.name
      has_qa = true if QAUSERS.include?(assignee)
      unless POSSIBLE_USERS.include?(assignee)
        @errors << "Strange subtask #{subtask.key} assignee #{assignee}"
      end
      next unless FT2USERS.include?(assignee)
      subtasks_total << subtask
      total_time = subtask.aggregatetimeoriginalestimate
      subtasks_noestimation << subtask if total_time.nil? || total_time.zero?
    end
    @errors << 'No QA subtask is assigned' unless has_qa
    @errors << "Total number of subtasks #{subtasks_total.count}" if subtasks_total.count.zero?
    subtasks_noestimation.each do |subtask|
      @errors << "Unestimated subtask #{subtask.key}"
    end
    print_errors
  end

  private

  def dump
    puts "#{issue.key} - #{issue.summary} - for #{issue.assignee.name}"
    @errors.each do |error|
      puts error
    end
    puts ''
  end

  def print_errors
    return if @errors.empty?
    dump
  end

  def filter_issue?
    issue.summary.downcase.include?('plan') && issue.summary.downcase.include?('sprint')
  end
end
