class AssociateBetsWithUser < ActiveRecord::Migration[5.2]
  def change
    change_table :bets do |t|
      t.belongs_to :user, foreign_key: true
    end
  end
end
