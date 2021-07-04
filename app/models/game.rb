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

    def users_season_games(season_id, user)
        Game.where(season_id: season.id).where('away_team_id=? OR home_team_id=?', user.id, user.id)
    end

    def game_number(season_id, user)
        users_season_games(season_id, user).find_index(self)
    end

end
