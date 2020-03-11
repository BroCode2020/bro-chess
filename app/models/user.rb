class User < ApplicationRecord
   has_many :pieces
   has_many :games

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook]

def self.new_with_session(params, session)
  super.tap do |user|
    if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
      user.email = data["email"] if user.email.blank?
    end
  end
end

def self.from_omniauth(auth)
  where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
    user.email = auth.info.email
    user.password = Devise.friendly_token[0,20]
    user.name = auth.info.name   # assuming the user model has a name
    user.image = auth.info.image # assuming the user model has an image
  end
 end

  def increment_loss_count
    loss_count = games_lost
    update_attribute(:games_lost, loss_count + 1)
  end

  def increment_tie_count
    tie_count = games_tied
    update_attribute(:games_tied, tie_count + 1)
  end

  def increment_win_count
    win_count = games_won
    update_attribute(:games_won, win_count + 1)
  end

end
