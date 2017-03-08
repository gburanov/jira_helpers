require 'jira-ruby'
require 'byebug'
require 'dotenv'
Dotenv.load

options = {
  username: ENV['USER'],
  password: ENV['PASSWORD'],
  site: 'https://hitfoxgamefinder.atlassian.net/',
  context_path: '',
  auth_type: :basic
}

startDate = Date.parse('22.02.2017')

client = JIRA::Client.new(options)
filter = client.Filter.find('24701')
issues = JIRA::Resource::Issue.jql(client, filter.jql, start_at: nil, max_results: 1000)
array = {}
authors = {}

issues.each do |issue|
  issue.fetch
  worklogs = issue.worklogs
  worklogs.each do |worklog|
    date = Date.parse(worklog.created)
    next if startDate > date
    author = worklog.author.name
    array[date] = {} if array[date].nil?
    array[date][author] = [] if array[date][author].nil?
    array[date][author] << worklog
    authors[author] = 0 if authors[author].nil?
    authors[author] += worklog.timeSpentSeconds
    print '.'
  end
end

array = Hash[array.sort]
puts ''

array.each do |date, authors|
  puts date.to_s
  authors.each do |author, worklogs|
    puts author.to_s
    worklogs.each do |worklog|
      puts "  #{worklog.issue.key} - #{worklog.issue.summary} - #{worklog.timeSpent}"
    end
  end
  puts ''
end

authors.each do |author, time|
  puts "#{author} - #{time / 60 / 60 / 8}days - #{time / 60 / 60}hours"
end
