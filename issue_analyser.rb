FT2USERS = ['alfredo.castaneda', 'francisco.sokol', 'georgy.buranov', 'post.vittorius', 'adrienmoreau']

class IssueAnalyser
  attr_reader :issue
  attr_reader :client

  def initialize(client, issue)
    @issue = issue
    @client = client
  end

  def call
    key = issue.key
    return if issue.summary.downcase.include?('plan') && issue.summary.downcase.include?('sprint')
    subtasks_total = []
    subtasks_noestimation = []
    subtasks = JIRA::Resource::Issue.jql(client, "parent = #{key}")
    subtasks.each do |subtask|
      assignee = subtask.assignee.name
      next unless FT2USERS.include?(assignee)
      subtasks_total << subtask
      total_time = subtask.aggregatetimeoriginalestimate
      subtasks_noestimation << subtask if total_time.nil? || total_time.zero?
    end
    if subtasks_total.count == 0 || subtasks_noestimation.count > 0
      puts "#{issue.key} - #{issue.summary} - for #{issue.assignee.name}"
      puts "Total number of subtasks #{subtasks_total.count}"
      puts "From them unestimated #{subtasks_noestimation.count}"
    end
  end

  def filter_issue?
  end

  def filter_subtask?
  end
end
