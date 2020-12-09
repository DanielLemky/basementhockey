class CreateResults < ActiveRecord::Migration[6.0]
  def change
    create_table :results do |t|
      t.belongs_to :game
      t.integer :home_goals
      t.integer :away_goals
      t.integer :overtime
      t.integer :shootout

      t.timestamps
    end
  end
end
