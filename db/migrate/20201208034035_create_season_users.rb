class CreateSeasonUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :season_users do |t|
      t.belongs_to :season
      t.belongs_to :user
      t.integer :user_role

      t.timestamps
    end
  end
end
