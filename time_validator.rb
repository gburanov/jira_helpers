class TimeValidator
  attr_reader :issues
  attr_reader :start_date

  def initialize(issues, start_date)
    @issues = issues
    @start_date = start_date
  end

  def call
    @array = {}
    @authors = {}

    issues.each do |issue|
      issue.fetch
      worklogs = issue.worklogs
      worklogs.each do |worklog|
        date = Date.parse(worklog.created)
        next if start_date > date
        author = worklog.author.name
        @array[date] = {} if @array[date].nil?
        @array[date][author] = [] if @array[date][author].nil?
        @array[date][author] << worklog
        @authors[author] = 0 if @authors[author].nil?
        @authors[author] += worklog.timeSpentSeconds
        print '.'
      end
    end

    @array = Hash[@array.sort]
    report
  end

  private

  def report
    puts ''

    @array.each do |date, authors|
      puts date.to_s
      authors.each do |author, worklogs|
        puts author.to_s
        worklogs.each do |worklog|
          puts "  #{worklog.issue.key} - #{worklog.issue.summary} - #{worklog.timeSpent}"
        end
      end
      puts ''
    end

    @authors.each do |author, time|
      puts "#{author} - #{time / 60 / 60 / 8}days - #{time / 60 / 60}hours"
    end
  end
end
