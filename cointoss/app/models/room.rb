class Room < ApplicationRecord
    #validates_on_update :house_wallet, numericality: {
    #    if: :deposit_into_room?,
    #    less_than_or_equal_to: User.find(:host_id).account_balance,
    #    greater_than_or_equal_to: 0,
    #    message: "Initial room account balance must be less than or equal to the users account balance."
    #}
    validates :max_bet, numericality: {
        less_than_or_equal_to: :house_wallet,
        message: "must be less than or equal to the initial room account balance."
    }

end
