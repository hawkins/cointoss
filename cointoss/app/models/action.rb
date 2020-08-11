class Action < ApplicationRecord
  belongs_to :room

  validates :odds, numericality: {
      greater_than: 0,
      less_than: 100,
      message: "must be between 0 and 100"
  }
  validates :room_id, numericality: true
  validates :description, presence: true
end
