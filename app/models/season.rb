class Season < ApplicationRecord
    has_many :season_users
    has_many :users, through: :season_users
    has_many :games
    has_many :results, through: :games
    has_many :team_stats

    enum season_type: [:season, :tournament]
    after_initialize :set_default_season_type, :if => :new_record?
    def set_default_season_type
        self.season_type ||= :season
    end
end
