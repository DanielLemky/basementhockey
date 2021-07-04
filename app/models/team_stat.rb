class TeamStat < ApplicationRecord
    belongs_to :season
    belongs_to :user

    def add_stat(column, amount)
        self[column] = self[column] + amount
    end

    def add_goal_stats(result, team)
        if team == result.game.home_team
            self.add_stat(:goals_for, result.home_goals)
            self.add_stat(:goals_against, result.away_goals)
        else
            self.add_stat(:goals_for, result.away_goals)
            self.add_stat(:goals_against, result.home_goals)
        end
    end

    def update_goal_difference
        self.goal_difference = self.goals_for - self.goals_against
    end

    def update_win_stats
        self.add_stat(:wins, 1)
        self.add_stat(:points, 2)
    end

    def update_loss_stats(result)
        if result.overtime == 1
            self.add_stat(:overtime_losses, 1)
            self.add_stat(:points, 1)
        else
            self.add_stat(:losses, 1)
        end
    end

end
