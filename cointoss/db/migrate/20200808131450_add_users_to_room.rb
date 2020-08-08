class AddUsersToRoom < ActiveRecord::Migration[5.2]
  def change
    add_reference :rooms, :users, foreign_key: true
  end
end
