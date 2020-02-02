class Game < ApplicationRecord
  has_many :pieces
  has_many :users

  scope :available, -> { where(available: true) }
end
