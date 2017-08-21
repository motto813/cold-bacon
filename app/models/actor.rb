class Actor < ApplicationRecord
  has_many :roles
  has_many :movies_appeared_in, through: :roles, source: :movie
  has_many :paths, as: :traceable

  validates_presence_of :name, :image_url, :tmdb_id
  validates_uniqueness_of :name, :tmdb_id

  def self.random_qualified_starting_actors
    self.popular_actors.order("RANDOM()")
  end

  def self.popular_actors
    self.where("popularity > ?", self.minimum_popularity)
  end

  def most_relevant_movies
    populate_movie_categories
    all_relevant_movies.limit(8)
  end

  def populate_movie_categories
    find_or_create_known_for_movies
    find_or_create_popular_movies_appeared_in
  end

  def all_relevant_movies
    movies_appeared_in.joins(:roles).order("roles.is_known_for ASC", popularity: :desc)
  end

  def find_or_create_known_for_movies
    if known_for_movies.count < desired_known_for_movies
      tmdb_chosen_known_for_movies.each do |tmdb_movie|
        find_or_create_known_for_movie_role_from_tmdb(tmdb_movie)
      end
    end
  end

  def known_for_movies
    movies_appeared_in.joins(:roles).where("roles.is_known_for = ?", true)
  end

  def tmdb_chosen_known_for_movies
    search_tmdb_for_actor.first["known_for"]
  end

  def search_tmdb_for_actor
    search = Tmdb::Search.new
    search.resource("person")
    search.query(name)
    search.fetch
  end

  def find_or_create_known_for_movie_role_from_tmdb(tmdb_movie)
    known_for_movie = Movie.find_or_initialize_by(name: tmdb_movie["title"], tmdb_id: tmdb_movie["id"], image_url: tmdb_movie["poster_path"])
    known_for_movie.popularity = tmdb_movie["popularity"]
    known_for_movie.save
    role = Role.find_or_initialize_by(actor: self, movie: known_for_movie)
    role.is_known_for = true
    role.save
  end

  def find_or_create_popular_movies_appeared_in
    if all_relevant_movies.count < desired_relevant_movies
      medias = media_credits_for_actor
      popular_movies = medias.select { |media| media["media_type"] == "movie" }.sort_by { |movie| movie["popularity"] }.reverse
      popular_movies[0...(desired_relevant_movies + 1)].each do |tmdb_movie|
        find_or_create_role_in_popular_movie_from_tmdb(tmdb_movie)
      end
    end
  end

  def popular_movies_appeared_in
    movies_appeared_in.joins(:roles).where("roles.is_known_for = ? OR roles.is_known_for IS ?", false, nil)
  end

  def media_credits_for_actor
    Tmdb::Person.credits(tmdb_id)["cast"]
  end

  def find_or_create_role_in_popular_movie_from_tmdb(tmdb_movie)
    popular_movie = Movie.find_or_initialize_by(name: tmdb_movie["title"], tmdb_id: tmdb_movie["id"], image_url: tmdb_movie["poster_path"])
    popular_movie.popularity = tmdb_movie["popularity"]
    popular_movie.save
    role = Role.find_or_initialize_by(actor: self, movie: popular_movie)
    role.save
  end

  private
  def desired_relevant_movies
    8
  end

  def desired_known_for_movies
    3
  end

  def self.minimum_popularity
    7.00
  end
end
