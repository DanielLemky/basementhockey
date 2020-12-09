class Season < ApplicationRecord
    has_many :season_users
    has_many :users, through: :season_users
    has_many :games
end
