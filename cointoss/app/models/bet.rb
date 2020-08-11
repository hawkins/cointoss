class Bet < ApplicationRecord
  belongs_to :room
  belongs_to :user

  validates_associated :user
  validates_associated :room

  validates :room_id, numericality: true

  validates :odds, numericality: {
      greater_than: 0,
      less_than: 100,
      message: "must be between 0 and 100"
  }

  validates :description, presence: true

  validates :user_id, numericality: true


  validate :wager_amount_must_fit_user_and_room
  def wager_amount_must_fit_user_and_room
    user = User.find_by(id: user_id)
    room = Room.find_by(id: room_id)

    user.account_balance -= wager_amount
    errors.add(:wager_amount, "#{wager_amount} cannot exceed user's account balance") if user.invalid?

    # room.risk += potential_earning
    # errors.add(:wager_amount, "payout (#{potential_earning}) exceeds what the house can afford") if room.invalid?

    errors.add(:wager_amount, "#{wager_amount} must be less than room's max bet #{room.max_bet}") if wager_amount > room.max_bet

    errors.add(:wager_amount, "#{wager_amount} must be greater than room's min bet #{room.min_bet}") if wager_amount < room.min_bet
  end

  def potential_earning
    (wager_amount * (100 / odds)).to_i
  end
end
