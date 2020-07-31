class AddAccountBalanceToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :account_balance, :integer
  end
end
