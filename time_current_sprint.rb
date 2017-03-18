# frozen_string_literal: true

require 'jira-ruby'
require 'byebug'
require 'dotenv'
require_relative 'time_validator'
require_relative 'person_time_analyser'
Dotenv.load

options = {
  username: ENV['USER_EMAIL'],
  password: ENV['PASSWORD'],
  site: 'https://hitfoxgamefinder.atlassian.net/',
  context_path: '',
  auth_type: :basic
}
client = JIRA::Client.new(options)
filter = client.Filter.find('24701')
issues = JIRA::Resource::Issue.jql(client, filter.jql, start_at: nil, max_results: 1000)

vacations = VacationsImporter.new.import
person_time = PersonTimeAnalyser.new(START_DATE, vacations)

TimeValidator.new(issues, person_time).call
