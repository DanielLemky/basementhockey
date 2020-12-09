class CreateSeasons < ActiveRecord::Migration[6.0]
  def change
    create_table :seasons do |t|
      t.string :name
      t.integer :status
      t.integer :season_type
      t.date :start_date
      t.integer :games_per_week

      t.timestamps
    end
  end
end
