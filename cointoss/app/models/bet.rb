class Bet < ApplicationRecord
  # validates :wager_amount, numericality: {
  #     on: :create,
  #     less_than_or_equal_to: RoomsHelper.user.account_balance,
  #     greater_than_or_equal_to: 0,
  #     message: "must be greater than 0 and less than your current account balance."
  # }
  #
  # validates :wager_amount, numericality: {
  #     on: :create,
  #     less_than_or_equal_to: RoomsHelper.room.max_bet,
  #     greater_than_or_equal_to: RoomsHelper.room.min_bet,
  #     message: "must be between the min and max bets of the room."
  # }
  #
  # validates :wager_amount, numericality: {
  #     on: :create,
  #     less_than_or_equal_to: RoomsHelper.room.house_wallet,
  #     message: "must be lower than the house wallet. They just can't afford it, dumbass. They're not backed by gold, you know. Try a lower bet."
  # }

  validates :wager_amount, numericality: {
      on: :create,
      greater_than: 0,
      message: "must be greater than 0."
  }

  belongs_to :room
  belongs_to :user

  def potential_earning
    (self.wager_amount * (100 / self.odds)).to_i
  end
end
