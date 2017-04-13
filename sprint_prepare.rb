# frozen_string_literal: true
require_relative 'lib/client.rb'
require_relative 'lib/new_sprint_analyser'
require_relative 'lib/vacations_importer'
require_relative 'lib/person_time_analyser'

if ARGV.empty?
  vacations = VacationsImporter.new.import
  person_time = PersonTimeAnalyser.new(NEXT_SPRINT_START, vacations)
  person_time.total
  puts ''
end

client = default_client
filter = client.Filter.find('26004')
issues = JIRA::Resource::Issue.jql(client, filter.jql, start_at: nil, max_results: 1000)
NewSprintAnalyser.new(client, issues).call(ARGV[0])
