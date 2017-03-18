class IssuePresenter
  attr_reader :issue

  def initialize(issue)
    @issue = issue
  end

  def call
    "#{issue.key} - #{issue.summary}(#{parent})"
  end

  private

  def parent
    issue.parent['fields']['summary']
  end
end
