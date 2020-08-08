class CreateActions < ActiveRecord::Migration[5.2]
  def change
    create_table :actions do |t|
      t.string :description
      t.float :odds
      t.string :game_name
      t.belongs_to :room, foreign_key: true

      t.timestamps
    end
  end
end
