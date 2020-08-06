class AddActionsAndBetsToRooms < ActiveRecord::Migration[5.2]
  def change
      add_column :rooms, :active_actions, :json, array: true, default: []
      add_column :rooms, :alltime_actions, :json, array: true, default: []
      add_column :rooms, :active_bets, :json, array: true, default: []
      add_column :rooms, :alltime_bets, :json, array: true, default: []
      add_column :rooms, :room_state, :integer
      add_column :rooms, :house_wallet, :integer
  end
end
