class Room < ApplicationRecord
    validates :house_wallet, numericality: {
        on: :update,
        less_than_or_equal_to: User.find(:host_id).account_balance,
        message: "Initial room account balance must be less than or equal to the users account balance."
    }
    validates :max_bet, numericality: {
        on: :update,
        less_than_or_equal_to: :house_wallet,
        message: "Max bet must be less than or equal to the initial room account balance."
    }

end
