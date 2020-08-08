class AddRoomToUsers < ActiveRecord::Migration[5.2]
  def change
    add_reference :users, :room, foreign_key: true
  end
end
