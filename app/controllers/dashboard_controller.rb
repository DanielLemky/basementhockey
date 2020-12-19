class DashboardController < ApplicationController
    before_action :authenticate_user!

    def index
        @seasons = current_user.seasons
        @next_game = Game.includes(:result).where(results: { id: nil}).where('away_team_id=? OR home_team_id=?', current_user.id, current_user.id ).first
    end

end
