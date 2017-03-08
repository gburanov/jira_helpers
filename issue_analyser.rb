FT2USERS = ['alfredo.castaneda', 'francisco.sokol', 'georgy.buranov', 'post.vittorius', 'adrienmoreau']

class IssueAnalyser
  def initialize(issue)
    @issue = issue
  end
  
  def call
    key = issue.key
    subtasks_total = []
    subtasks_noestimation = []
    subtasks = JIRA::Resource::Issue.jql(client, "parent = #{key}")
    subtasks.each do |subtask|
      assignee = subtask.assignee.name
      next unless FT2USERS.include?(assignee)
      subtasks_total << subtask
      total_time = subtask.progress['total']
      subtasks_noestimation << subtask if total_time.zero?
    end
    if subtasks_total.count == 0 || subtasks_noestimation.count > 0
      puts "#{issue.key} - #{issue.summary} - for #{issue.assignee.name}"
      puts "Total number of subtasks #{subtasks_total.count}"
      puts "From them unestimated #{subtasks_noestimation.count}"
    end
  end
end
