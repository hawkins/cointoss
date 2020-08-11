class User < ApplicationRecord
    has_secure_password

    has_one :room

    validates :username, uniqueness: { message: "is already taken" }
    validates :password_digest, presence: true
    validates :account_balance, numericality: { greater_than_or_equal_to: 0 }
end
