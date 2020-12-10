class CreateTeamStats < ActiveRecord::Migration[6.0]
  def change
    create_table :team_stats do |t|
      t.belongs_to :user
      t.belongs_to :season
      t.integer :wins
      t.integer :losses
      t.integer :overtime_losses
      t.integer :points
      t.integer :goals_for
      t.integer :goals_against
      t.integer :goal_difference

      t.timestamps
    end
  end
end
