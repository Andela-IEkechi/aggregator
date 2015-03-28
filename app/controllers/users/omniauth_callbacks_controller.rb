class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def slack
    @user = User.find_for_slack(request.env["omniauth.auth"], current_user)

    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", kind: "Slack"
      sign_in_and_redirect @user, event: :authentication
    else
      puts @user.errors.first
      session["devise.slack_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end
end