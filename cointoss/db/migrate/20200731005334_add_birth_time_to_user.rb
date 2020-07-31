class AddBirthTimeToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :birth_time, :integer
  end
end
