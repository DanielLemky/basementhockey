class SeasonsController < ApplicationController
    before_action :authenticate_user!
    
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

    def standings
        @season = Season.find(params[:season_id])
        @teams = @season.users
        @team_stats = TeamStat.where(season_id: @season.id).order(points: :desc, goal_difference: :desc)
    end

    def new_user
        @season = Season.find(params[:season_id])
        @users = User.all
    end

    def add_user
        @season = Season.find(params[:season_id])
        @user = User.find(params[:user])
        @season.users << @user
        redirect_to @season
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
