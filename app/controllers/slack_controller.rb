class SlackController < ApplicationController
  include HTTParty
  base_uri 'https://slack.com/api/files.list'

  def initialize(service, page, current_user)
    token = current_user.token
    @options = { query: {site: service, page: page, token: token, ts_from: DateTime.now.beginning_of_day} }
  end

  def files
    self.class.get("/files.list", @options)
  end

  def users
    self.class.get("/users.list", @options)
  end
end