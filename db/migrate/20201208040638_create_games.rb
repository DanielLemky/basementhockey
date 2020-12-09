class CreateGames < ActiveRecord::Migration[6.0]
  def change
    create_table :games do |t|
      t.belongs_to :home_team, class_name: :user
      t.belongs_to :away_team, class_name: :user
      t.integer :status
      t.belongs_to :season

      t.timestamps
    end
  end
end
