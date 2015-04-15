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

  def get_user_token(current_user)
    token = current_user.token
    create_channel
    @activity = { query: {token: token, username: "MakeItBetter", channel: @channel, text: "Testing" }}
  end

  def get_channel_info
    @history = { query: {token: @token, channel: @channel, inclusive: 1, count: 1000}}
  end

  def suggestion_box_post
    HTTParty.post("https://slack.com/api/chat.postMessage", get_user_token(current_user))
  end

  def create_channel
    @token = current_user.token
    @new_channel = { query: { token: @token, name: "suggestion-box" }}
    response = HTTParty.get("https://slack.com/api/channels.list", set_user_option(current_user))
    if response["channels"].find { |obj| obj["name"] == "suggestion-box" && obj["is_archived"] == false} == nil
      @channel = HTTParty.post("https://slack.com/api/channels.create", @new_channel)["channel"]["id"]
    else
      @channel = response["channels"].find { |obj| obj["name"] == "suggestion-box" && obj["is_archived"] == false}["id"]
    end
  end

  def get_history
    HTTParty.get("https://slack.com/api/channels.history", get_channel_info)["messages"]
  end
end