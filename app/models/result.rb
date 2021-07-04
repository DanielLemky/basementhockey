class Result < ApplicationRecord
    belongs_to :game
    has_one_attached :game_photo

    after_create :add_result_to_stats

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

    def add_result_to_stats
        winner_stats = self.winner.team_stats.find_by(season_id: self.game.season_id)
        loser_stats = self.loser.team_stats.find_by(season_id: self.game.season_id)

        winner_stats.update_win_stats
        loser_stats.update_loss_stats(self)

        winner_stats.add_goal_stats(self, self.winner)
        loser_stats.add_goal_stats(self, self.loser)

        winner_stats.update_goal_difference
        loser_stats.update_goal_difference

        winner_stats.save
        loser_stats.save
    end

end
