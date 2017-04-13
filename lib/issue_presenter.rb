class IssuePresenter
  attr_reader :issue

  def initialize(issue)
    @issue = issue
  end

  def call
    "#{issue.key} - #{issue.summary}(#{parent})"
  end

  def full
    "#{call}. Author #{author}. Status #{status}"
  end

  private

  def author
    issue.assignee.name
  end

  def status
    issue.status.name
  end

  def parent
    return '' if issue.try(:parent).nil?
    issue.parent['fields']['summary']
  end
end
