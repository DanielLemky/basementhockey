class AddToSeasonsLengthInWeeks < ActiveRecord::Migration[6.0]
  def change
    add_column :seasons, :length_in_weeks, :integer
  end
end
