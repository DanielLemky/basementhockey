class GamesController < ApplicationController
    before_action :authenticate_user!
    
    def new
        @season = Season.find(params[:season_id])
        @game = @season.games.new
        @teams = @season.users
    end

    def show
    end

    def edit
    end

    def index
        @season = Season.find(params[:season_id])
        @games = Game.where(season_id: @season.id)
    end

    def my
        @season = Season.find(params[:season_id])
        @games = Game.where(season_id: @season.id).where('away_team_id=? OR home_team_id=?', current_user.id, current_user.id)
    end

    def create
        @game = Game.new(game_params)

        if @game.save
            redirect_to season_games_path(@game.season_id)
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
            params.permit(:home_team_id, :away_team_id, :status, :season_id)
        end
end
