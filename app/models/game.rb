class Game < ApplicationRecord
    belongs_to :season
    has_one :home_team, class_name: :user, foreign_key: :home_team
    has_one :away_team, class_name: :user, foreign_key: :away_team
    has_one :result
    has_one :game_time

    def home_team
        User.find(home_team_id)
    end

    def away_team
        User.find(away_team_id)
    end
end
