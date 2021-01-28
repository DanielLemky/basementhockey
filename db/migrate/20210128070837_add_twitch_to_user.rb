class AddTwitchToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :twitch, :string
  end
end
