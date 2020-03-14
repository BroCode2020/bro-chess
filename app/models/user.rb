class User < ApplicationRecord
  has_many :pieces
  has_many :games

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

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
