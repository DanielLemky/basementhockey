class ResultsController < ApplicationController
    before_action :authenticate_user!

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
        update_stats

        if @result.save
            flash.alert = 'Success! Your results have been saved.'
            redirect_to season_games_path(@game.season_id)
        else
            redirect_to new_game_result_path(game)
        end
    end

    private
        def result_params
            params.permit(:away_goals, :home_goals, :overtime, :shootout, :game_id, :game_photo)
        end

        def winner(result)
            if result.home_goals < result.away_goals
                winner = User.find(result.game.away_team_id)
            else
                winner = User.find(result.game.home_team_id)
            end
        end

        def loser(result)
            if result.home_goals < result.away_goals
                loser = User.find(result.game.home_team_id)
            else
                loser = User.find(result.game.away_team_id)
            end
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

        def update_stats
            winner_stats = winner(@result).team_stats.find_by(season_id: @game.season_id)
            loser_stats = loser(@result).team_stats.find_by(season_id: @game.season_id)

            winner_stats = add_win_stats(winner_stats)
            loser_stats = add_loss_stats(loser_stats)


            if @result.home_goals < @result.away_goals
                # away won
                winner_stats.goals_for = winner_stats.goals_for + @result.away_goals
                loser_stats.goals_for = loser_stats.goals_for + @result.home_goals

                winner_stats.goals_against = winner_stats.goals_against + @result.home_goals
                loser_stats.goals_against = loser_stats.goals_against + @result.away_goals
            else
                # home won
                winner_stats.goals_for = winner_stats.goals_for + @result.home_goals
                loser_stats.goals_for = loser_stats.goals_for + @result.away_goals

                winner_stats.goals_against = winner_stats.goals_against + @result.away_goals
                loser_stats.goals_against = loser_stats.goals_against + @result.home_goals
            end
            winner_stats.goal_difference = winner_stats.goals_for - winner_stats.goals_against
            loser_stats.goal_difference = loser_stats.goals_for - loser_stats.goals_against


            winner_stats.save
            loser_stats.save
            
        end
end
