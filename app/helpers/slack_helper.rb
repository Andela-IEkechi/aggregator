module SlackHelper

  def set_user_option(current_user)
    token = current_user.token
    @options = { query: {token: token, ts_from: (DateTime.now - 7.days).beginning_of_day.to_time.to_i, count: 200}}
  end

  def slack_files
    HTTParty.get("https://slack.com/api/files.list", set_user_option(current_user))["files"]
  end

  def slack_user
    response = HTTParty.get("https://slack.com/api/users.list", set_user_option(current_user))
    response["members"].find { |obj| obj["id"] == current_user.uid }
  end

  def update_current_user
    details = {
      email: slack_user["profile"]["email"],
      name: slack_user["profile"]["real_name"],
      image: slack_user["profile"]["image_original"]
    }
    current_user.update_attributes!(details)
  end

  def set_options_for_query(current_user)
    token = current_user.token
    @content = { query: {token: token, count: 100, query: 'http'}}
  end
  def slack_links
    HTTParty.get("https://slack.com/api/search.messages", set_options_for_query(current_user))["messages"]["matches"]
  end
end