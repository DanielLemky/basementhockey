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
        if @season.users.exists?(@user.id)
            flash.alert = "User is already added to this season"
            redirect_to season_new_user_path(@season)
        else
            @season.users << @user
            @user.team_stats.create(season_id: @season.id, wins: 0, losses: 0, overtime_losses: 0, points: 0, goals_for: 0, goals_against: 0, goal_difference: 0 )
            redirect_to @season
        end
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
