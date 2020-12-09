class SeasonsController < ApplicationController
    def new
        @season = Season.new
    end

    def show
        @season = Season.find(params[:id])
    end

    def index
    end

    def edit
    end

    def create
        @season = Season.new(season_params)

        if @season.save
            redirect_to @season
        else
            redirect_to new_season_path
        end
    end

    def update
    end

    def destroy
    end

    private
        def season_params
            params.require(:season).permit(:name, :season_type, :start_date, :games_per_week)
        end
end
