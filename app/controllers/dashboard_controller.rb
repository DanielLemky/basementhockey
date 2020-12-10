class DashboardController < ApplicationController
    before_action :authenticate_user!

    def index
        @seasons = current_user.seasons
        @next_game = Game.where('away_team_id=? OR home_team_id=?', current_user.id, current_user.id ).where(status: 0).first
        @results = Result.all.order(created_at: :desc).limit(5)
    end

end
