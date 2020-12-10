class ResultsController < ApplicationController
    before_action :authenticate_user!

    def new
        @game = Game.find(params[:game_id])
        @result = @game.build_result
    end

    def create
        @game = Game.find(params[:game_id])
        @result = @game.build_result(result_params)
        
        if @result.save
            redirect_to @game
        else
            redirect_to new_game_result_path(game)
        end
    end

    private
        def result_params
            params.permit(:away_goals, :home_goals, :overtime, :shootout)
        end
end
