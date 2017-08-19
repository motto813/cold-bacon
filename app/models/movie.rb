class Movie < ApplicationRecord
  has_many :roles
  has_many :leading_actors, through: :roles, source: :actor
  has_many :paths, as: :traceable

  validates_presence_of :title, :image_url, :tmdb_id
  validates_uniqueness_of :title, :tmdb_id

  def get_top_billed_actors
    get_full_movie_cast[0...8]
  end

  def get_full_movie_cast
    Tmdb::Movie.casts(tmdb_id)
  end
end
