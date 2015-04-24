class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :authentication_keys => [:uid]


  devise :omniauthable, :omniauth_providers => [:slack]

  def self.find_for_slack(access_token, signed_in_resource=nil)
    data = access_token.info
    user = User.where(provider: access_token.provider, uid: access_token.uid ).first
    if user
      return user
    else
      registered_user = User.where(:uid => access_token.uid).first
      if registered_user
        return registered_user
      else
        user = User.create(nickname: data["user"],
                           provider:access_token.provider,
                           team: data["team"],
                           team_id: data["team_id"],
                           uid: access_token.uid ,
                           team_url: access_token.extra.raw_info.url,
                           token: access_token.credentials.token,
                           password: Devise.friendly_token[0,20]
        )
      end
    end
  end
end
