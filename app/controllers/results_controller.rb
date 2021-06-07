class ResultsController < ApplicationController
    before_action :authenticate_user!
    after_action :update_stats, only: [:create]

    def new
        @game = Game.find(params[:game_id])
        
        if current_user.id == @game.home_team_id  or  current_user.id == @game.away_team_id
            @result = @game.build_result
        else
            redirect_to season_games_path(@game.season_id)
        end
    end

    def show
        @game = Game.find(params[:game_id])
    end

    def create
        @game = Game.find(params[:game_id])
        @result = @game.build_result(result_params)

        if @result.save
            flash.alert = 'Success! Your results have been saved.'
            redirect_to season_games_path(@game.season_id)
        else
            redirect_to new_game_result_path(game)
        end
    end

    protected
        def result_params
            params.permit(:away_goals, :home_goals, :overtime, :shootout, :game_id, :game_photo)
        end

        def update_stats
            winner_stats = @result.winner.team_stats.find_by(season_id: @game.season_id)
            loser_stats = @result.loser.team_stats.find_by(season_id: @game.season_id)

            winner_stats = add_win_stats(winner_stats)
            loser_stats = add_loss_stats(loser_stats)

            winner_stats = goal_stats(@result, @result.winner, winner_stats)
            loser_stats = goal_stats(@result, @result.loser, loser_stats)

            winner_stats.goal_difference = winner_stats.goals_for - winner_stats.goals_against
            loser_stats.goal_difference = loser_stats.goals_for - loser_stats.goals_against

            winner_stats.save
            loser_stats.save
        end

        def add_win_stats(team_stats)
            team_stats.wins = team_stats.wins + 1
            team_stats.points = team_stats.points + 2
            team_stats
        end

        def add_loss_stats(team_stats)
            if @result.overtime == 1
                team_stats.overtime_losses = team_stats.overtime_losses + 1
                team_stats.points = team_stats.points + 1
            else
                team_stats.losses = team_stats.losses + 1
            end
            team_stats
        end

        def goal_stats(result, team, team_stats)
            # Goals For
            if team == result.game.home_team
                team_stats.goals_for = team_stats.goals_for + result.home_goals
            else
                team_stats.goals_for = team_stats.goals_for + result.away_goals
            end

            # Goals Against
            if team == result.game.home_team
                team_stats.goals_against = team_stats.goals_against + result.away_goals
            else
                team_stats.goals_against = team_stats.goals_against + result.home_goals
            end
            team_stats
        end
end
