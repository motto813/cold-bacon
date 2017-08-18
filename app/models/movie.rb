class Movie < ApplicationRecord
  has_many :roles
  has_many :leading_actors, through: :roles, source: :actor
  has_many :paths, as: :traceable

  validates_presence_of :title, :image_url, :tmdb_id
  validates_uniqueness_of :title, :tmdb_id
end
