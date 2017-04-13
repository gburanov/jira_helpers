# frozen_string_literal: true
require_relative 'lib/client.rb'
require_relative 'lib/time_validator'
require_relative 'lib/person_time_analyser'
require_relative 'lib/vacations_importer'

client = default_client
filter = client.Filter.find('24701')
issues = JIRA::Resource::Issue.jql(client, filter.jql, start_at: nil, max_results: 1000)

vacations = VacationsImporter.new.import
person_time = PersonTimeAnalyser.new(START_DATE, vacations)

TimeValidator.new(issues, person_time).call
