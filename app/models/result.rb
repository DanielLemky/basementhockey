class Result < ApplicationRecord
    belongs_to :game
    has_one_attached :game_photo
end
