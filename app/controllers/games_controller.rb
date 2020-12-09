class GamesController < ApplicationController
    def new
    end

    def show
    end

    def edit
    end

    def index
        @games = Game.all
    end

    def create
        @game = Game.new(game_params)

        if @game.save
            redirect_to @game
        else
            redirect_to new_game_path
        end
    end

    def update
    end

    def destroy
    end

    private
        def game_params
            params.require(:game).permit(:home_team_id, :away_team_id, :status, :season_id)
        end
end
