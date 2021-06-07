class Result < ApplicationRecord
    belongs_to :game
    has_one_attached :game_photo

    def winner
        if home_goals < away_goals
            game.away_team
        else
            game.home_team
        end
    end

    def loser
        if home_goals < away_goals
            game.home_team
        else
            game.away_team
        end
    end

end
