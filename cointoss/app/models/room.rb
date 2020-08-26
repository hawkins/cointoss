class Room < ApplicationRecord
    validates :house_wallet, numericality: {
       on: :create,
       less_than_or_equal_to: RoomsHelper.user.account_balance,
       greater_than_or_equal_to: 0,
       message: "Initial room account balance must be less than or equal to the users account balance."
    }
    validates :max_bet, numericality: {
        less_than_or_equal_to: :house_wallet,
        message: "must be less than or equal to the initial room account balance."
    }

    validates :host_id, presence: {
        on: :create,

    }
    
    has_many :users
    has_many :bets
    has_many :actions
end
