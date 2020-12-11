class SeasonUser < ApplicationRecord
    belongs_to :season
    belongs_to :user

    enum user_role: [:admin, :player]
    after_initialize :set_default_user_role, :if => :new_record?
    def set_default_user_role
        self.user_role ||= :player
    end
end
