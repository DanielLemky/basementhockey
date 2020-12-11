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

        def update_stats
            @game = Game.find(params[:game_id])
            @home_team = User.find(@game.home_team_id)
            @away_team = User.find(@game.away_team_id)

            if @result.home_goals < @result.away_goals
                @winner = @away_team
                @loser = @home_team
            else
                @winner = @home_team
                @loser = @away_team
            end

            @winner_stats = @winner.team_stats.where(season_id: @game.season_id).first
            @loser_stats = @loser.team_stats.where(season_id: @game.season_id).first

            @winner_stats.wins = @winner_stats.wins + 1
            @winner_stats.points = @winner_stats.points + 2

            if @result.overtime == 1
                @loser_stats.overtime_losses = @loser_stats.overtime_losses + 1
                @loser_stats.points = @loser_stats.points + 1
            else
                @loser_stats.losses = @loser_stats.losses + 1
            end

            if @result.home_goals < @result.away_goals
                # away won
                @winner_stats.goals_for = @winner_stats.goals_for + @result.away_goals
                @loser_stats.goals_for = @loser_stats.goals_for + @result.home_goals

                @winner_stats.goals_against = @winner_stats.goals_against + @result.home_goals
                @loser_stats.goals_against = @loser_stats.goals_against + @result.away_goals
            else
                # home won
                @winner_stats.goals_for = @winner_stats.goals_for + @result.home_goals
                @loser_stats.goals_for = @loser_stats.goals_for + @result.away_goals

                @winner_stats.goals_against = @winner_stats.goals_against + @result.away_goals
                @loser_stats.goals_against = @loser_stats.goals_against + @result.home_goals
            end
            
            @winner_stats.goal_difference = @winner_stats.goals_for - @winner_stats.goals_against
            @loser_stats.goal_difference = @loser_stats.goals_for - @loser_stats.goals_against


            @winner_stats.save
            @loser_stats.save
            
        end
end
