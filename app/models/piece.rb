class Piece < ApplicationRecord
  belongs_to :game, optional: true    # This has been modified for testing
  belongs_to :user, optional: true    # (same here)
end
