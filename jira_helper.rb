# frozen_string_literal: true

require 'pry'
require 'net/http'
require 'json'

JIRA_API_KITMANLABS = 'https://kitmanlabs.atlassian.net/rest/api/3/'

def jira_username
  `op read 'op://Private/Jira API Token/username'`.chop
end

def jira_token
  `op read 'op://Private/Jira API Token/password'`.chop
end

def get_request(uri_string:)
  uri = URI(uri_string)
  request = Net::HTTP::Get.new(uri)

  # circle request token request['Circle-Token'] = circle_token
  # jira auth
  request.basic_auth(jira_username, jira_token)
  req_options = { use_ssl: uri.scheme == 'https' }
  Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
    http.request(request)
  end
end

def post_request(uri_string:, data:)
  uri = URI(uri_string)
  request = Net::HTTP::Post.new(uri)

  request.basic_auth(jira_username, jira_token)
  req_options = { use_ssl: uri.scheme == 'https' }
  Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
    http.request(request, data)
  end
end

uri_string = JIRA_API_KITMANLABS + 'search?jql=text%20~%20"FlakySpec*"%20AND%20Labels=FlakySpec'
response = get_request(uri_string: uri_string)
body = JSON.parse(response.body)
binding.pry
