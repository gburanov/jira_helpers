# frozen_string_literal: true
require_relative 'constants'
require_relative 'issue_presenter'

class TimeValidator
  attr_reader :issues
  attr_reader :start_date
  attr_reader :person_time

  def initialize(issues, person_time)
    @issues = issues
    @start_date = START_DATE
    @person_time = person_time

    @array = {}
    @authors = {}
  end

  def call
    issues.each do |issue|
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
    person_time.call
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
      puts "#{author} - #{TimePresenter.new(spend_time(time)).call}. " +
           "Estimated is #{TimePresenter.new(estimated_time(author)).call}. " +
           "This is #{percents(author, time)}%"
    end
  end

  def percents(author, time)
    estimated_time(author).to_f / spend_time(time) * 100
  end

  def spend_time(time)
    time / 60 / 60
  end

  def estimated_time(author)
    person_time.estimated_for(author)
  end
end
