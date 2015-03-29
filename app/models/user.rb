class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable

  devise :omniauthable, :omniauth_providers => [:slack]

  def self.find_for_slack(code, signed_in_resource=nil)
    data = code.info
    user = User.where(provider: code.provider, uid: code.uid ).first
    if user
      return user
    else
      registered_user = User.where(:uid => code.uid).first
      if registered_user
        return registered_user
      else
        user = User.create(nickname: data["user"],
                           provider:code.provider,
                           team: data["team"],
                           team_id: data["team_id"],
                           uid: code.uid ,
                           team_url: code.extra.raw_info.url,
                           token: code.credentials.token,
                           password: Devise.friendly_token[0,20]
        )
      end
    end
  end
end
