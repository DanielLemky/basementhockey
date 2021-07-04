class Season < ApplicationRecord
    has_many :season_users
    has_many :users, through: :season_users
    has_many :games
    has_many :results, through: :games
    has_many :team_stats
    has_many :game_times, through: :games

    after_initialize :set_default_season_type, :if => :new_record?
    after_initialize :set_default_status, :if => :new_record?

    enum season_type: [:season, :tournament]
    enum status: [:closed, :open]

    def set_default_season_type
        self.season_type ||= :season
    end

    def set_default_status
        self.status ||= :open
    end

    def current_week
        if self.open?
            current_week = self.start_date.step(Date.today, 7).count
            if current_week > self.length_in_weeks
                current_week = self.length_in_weeks
            end
            "Current Week ##{current_week}"
        else
            "Season Is Closed"
        end
    end
end
