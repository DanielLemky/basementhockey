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

end
