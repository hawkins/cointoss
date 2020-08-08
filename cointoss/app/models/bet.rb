class Bet < ApplicationRecord
  validates :wager_amount, numericality: {
      on: :create,
      less_than_or_equal_to: RoomsHelper.user.account_balance,
      greater_than_or_equal_to: 0,
      message: "You can't afford that bet!"
  }

  validates :wager_amount, numericality: {
      on: :create,
      less_than_or_equal_to: RoomsHelper.room.max_bet,
      greater_than_or_equal_to: RoomsHelper.room.min_bet,
      message: "Your bet must be between the min and max bets of the room."
  }

  validates :wager_amount, numericality: {
      on: :create,
      less_than_or_equal_to: RoomsHelper.room.house_wallet,
      message: "The house can't afford to take that bet. They're not backed by gold, you know. Try a lower bet."
  }

  belongs_to :room
  belongs_to :user
end
