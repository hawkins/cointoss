class CreateRooms < ActiveRecord::Migration[5.2]
  def change
    create_table :rooms do |t|
      t.string :name
      t.integer :room_id
      t.datetime :creation_time
      t.text :current_users, array: true, default: []
      t.text :alltime_users, array: true, default: []
      t.integer :max_bet
      t.integer :max_users
      t.integer :min_bet
      t.string :game_name
      t.integer :host_id
      t.boolean :locked

      t.timestamps
    end
  end
end
