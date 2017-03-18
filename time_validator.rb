# frozen_string_literal: true
require_relative 'constants'
require_relative 'issue_presenter'

class TimeValidator
  attr_reader :issues
  attr_reader :start_date

  def initialize(issues)
    @issues = issues
    @start_date = Date.parse(START_DATE)

    @array = {}
    @authors = {}
  end

  def call
    issues[0...5].each do |issue|
      issue.fetch
      worklogs = issue.worklogs
      worklogs.each { |worklog| parse_worklog(worklog) }
    end
    @array = Hash[@array.sort]
    report
  end

  private

  def parse_worklog(worklog)
    date = Date.parse(worklog.created)
    return if start_date > date
    author = worklog.author.name
    @array[date] = {} if @array[date].nil?
    @array[date][author] = [] if @array[date][author].nil?
    @array[date][author] << worklog
    @authors[author] = 0 if @authors[author].nil?
    @authors[author] += worklog.timeSpentSeconds
    print '.'
  end

  def report
    puts ''

    @array.each do |date, authors|
      puts date.to_s
      authors.each do |author, worklogs|
        puts author.to_s
        worklogs.each do |worklog|
          issue = worklog.issue
          puts "  #{IssuePresenter.new(issue).call} - #{worklog.timeSpent}"
        end
      end
      puts ''
    end

    @authors.each do |author, time|
      puts "#{author} - #{time / 60 / 60 / 8}days - #{time / 60 / 60}hours"
    end
  end
end
