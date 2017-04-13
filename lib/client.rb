# frozen_string_literal: true

require 'jira-ruby'
require 'dotenv'

Dotenv.load

def default_client
  options = {
    username: ENV['USER_EMAIL'],
    password: ENV['PASSWORD'],
    site: 'https://hitfoxgamefinder.atlassian.net/',
    context_path: '',
    auth_type: :basic
  }

  JIRA::Client.new(options)
end
