class GameTimesController < ApplicationController
    before_action :authenticate_user!

    def new
        @game = Game.find(params[:game_id])

        if current_user.id == @game.home_team_id  or  current_user.id == @game.away_team_id
            @game_time = @game.build_game_time
        else
            redirect_to season_games_path(@game.season_id)
        end
    end

    def edit
        @game = Game.find(params[:game_id])

        if current_user.id == @game.home_team_id  or  current_user.id == @game.away_team_id
            @game_time = @game.game_time
        else
            redirect_to season_games_path(@game.season_id)
        end
    end

    def create
        @game = Game.find(params[:game_id])
        @game_time = @game.build_game_time(game_time_params)
        @game_time.date_time = Time.zone.parse(params[:date_time] + current_user.time_zone)
        @game_time.set_by_user_id = current_user.id

        if @game_time.save
            flash.alert = 'Success! Your game time has been scheduled.'
            redirect_to season_games_path(@game.season_id)
        else
            flash.alert = 'Error: An error occured while saving your game.'
            redirect_to new_game_game_time_path(game)
        end
    end

    def update
        @game = Game.find(params[:game_id])
        @game_time = @game.game_time
        @game_time.date_time = Time.zone.parse(params[:date_time] + current_user.time_zone)
        @game_time.set_by_user_id = current_user.id

        if @game_time.save
            flash.alert = 'Success! Your game time has been scheduled.'
            redirect_to season_games_path(@game.season_id)
        else
            flash.alert = 'Error: An error occured while saving your game.'
            redirect_to new_game_game_time_path(game)
        end
    end

    private
        def game_time_params
            params.permit(:game_id, :date_time, :set_by_user_id)
        end

end
