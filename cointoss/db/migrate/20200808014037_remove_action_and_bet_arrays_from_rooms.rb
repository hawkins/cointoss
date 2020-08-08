class RemoveActionAndBetArraysFromRooms < ActiveRecord::Migration[5.2]
  def change
      remove_column :rooms, :active_actions
      remove_column :rooms, :alltime_actions
      remove_column :rooms, :active_bets
      remove_column :rooms, :alltime_bets
  end
end
