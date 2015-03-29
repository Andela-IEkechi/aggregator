module SlackHelper

  def set_user_option(current_user)
    token = current_user.token
    @options = { query: {token: token, ts_from: DateTime.now.beginning_of_day} }
  end

  def slack_files
    puts self.inspect
    HTTParty.get("https://slack.com/api/files.list", set_user_option(current_user))["files"]
  end

  def slack_user
    response = HTTParty.get("https://slack.com/api/users.list", set_user_option(current_user))
    response["members"].find { |obj| obj["id"] == current_user.uid }
  end

  def update_current_user
    current_user.email = slack_user["profile"]["email"]
    current_user.name = slack_user["profile"]["real_name"]
    current_user.image = slack_user["profile"]["image_original"]
  end
end