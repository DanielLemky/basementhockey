class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :season_users
  has_many :seasons, through: :season_users
  has_many :games
  has_many :results, through: :games
  has_many :team_stats
  has_many :game_times, through: :games

  enum role: [:super_admin, :season_admin, :player]

  after_initialize :set_default_role, :if => :new_record?

  def set_default_role
    self.role ||= :player
  end
end
