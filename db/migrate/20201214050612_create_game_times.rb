class CreateGameTimes < ActiveRecord::Migration[6.0]
  def change
    create_table :game_times do |t|
      t.belongs_to :game
      t.datetime :date_time
      t.integer :set_by_user_id

      t.timestamps
    end
  end
end
