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

        if current_user.seasons.exists?(@season.id)
            @games = Game.where(season_id: @season.id)
            @current_week = @season.start_date.step(Date.today, 7).count
        else
            redirect_to root_path
        end
    end

    def my
        @season = Season.find(params[:season_id])
        if current_user.seasons.exists?(@season.id)
            @games = Game.where(season_id: @season.id).where('away_team_id=? OR home_team_id=?', current_user.id, current_user.id)
            @current_week = @season.start_date.step(Date.today, 7).count
        else
            redirect_to root_path
        end
    end

    def create
        @game = Game.new(game_params)

        unless @game.home_team_id == @game.away_team_id
            if @game.save
                flash.alert = "Success! Game was created."
                if params[:commit] == 'Create Game and New'
                    redirect_to new_season_game_path(@game.season_id)    
                else
                    redirect_to season_path(@game.season_id)
                end
            else
                flash.alert = "Error: Unknown"
                redirect_to new_game_path
            end
        else
            flash.alert = "Error: You selected the same team for away and home."
            redirect_to new_season_game_path(@game.season_id)
        end

    end

    def update
    end

    def destroy
    end

    private
        def game_params
            params.permit(:home_team_id, :away_team_id, :status, :season_id, :week)
        end
end
