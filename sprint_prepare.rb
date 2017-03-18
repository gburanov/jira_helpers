require 'jira-ruby'
require 'byebug'
require 'dotenv'
require_relative 'new_sprint_analyser'
require_relative 'vacations_importer'
require_relative 'person_time_analyser'
Dotenv.load

options = {
  username: ENV['USER_EMAIL'],
  password: ENV['PASSWORD'],
  site: 'https://hitfoxgamefinder.atlassian.net/',
  context_path: '',
  auth_type: :basic
}

vacations = VacationsImporter.new.import
person_time = PersonTimeAnalyser.new(NEXT_SPRINT_START, vacations)
person_time.total

client = JIRA::Client.new(options)
filter = client.Filter.find('26004')
issues = JIRA::Resource::Issue.jql(client, filter.jql, start_at: nil, max_results: 1000)
NewSprintAnalyser.new(client, issues).call
