class SeasonUser < ApplicationRecord
    belongs_to :season
    belongs_to :user
end
