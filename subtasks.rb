require 'jira-ruby'
require 'byebug'
require 'dotenv'
Dotenv.load

options = {
  username: ENV['USER_EMAIL'],
  password: ENV['PASSWORD'],
  site: 'https://hitfoxgamefinder.atlassian.net/',
  context_path: '',
  auth_type: :basic
}

startDate = Date.parse('22.02.2017')

client = JIRA::Client.new(options)

issue = client.Issue.find("AB-3944")


filter = client.Filter.find('26002')
issues = JIRA::Resource::Issue.jql(client, filter.jql, start_at: nil, max_results: 1000)

issues.each do |issue|
  issue.fetch
  IssueAnalyser.new(issue).call
end
