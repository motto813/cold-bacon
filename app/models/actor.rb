class Actor < ApplicationRecord
  has_many :roles
  has_many :top_movies, through: :roles, source: :movie
  has_many :paths, as: :traceable

  before_validation :set_top_movies

  validates_presence_of :name, :image_url, :tmdb_id
  validates_uniqueness_of :name, :tmdb_id

  def set_top_movies
    top_movies = get_top_movies(search_api_for_actor)
    top_movies.each do |movie|
      top_movie = Movie.find_or_create_by(tmdb_id: movie["id"])
      Role.find_or_create_by(actor: self, movie: top_movie)
    end
  end

  def search_api_for_actor
    search = Tmdb::Search.new
    search.resource("person")
    search.query(name)
    search.fetch
  end

  def get_top_movies(actor_object)
    actor_object.first["known_for"]
  end
end
