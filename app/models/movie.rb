class Movie < ApplicationRecord
  has_many :roles
  has_many :featured_actors, through: :roles, source: :actor
  has_many :paths, as: :traceable

  validates_presence_of :name, :image_url, :tmdb_id, :popularity
  validates_uniqueness_of :tmdb_id

  def top_billed_actors
    find_or_create_top_billed_actors
    featured_actors.order(popularity: :desc)
  end

  def find_or_create_top_billed_actors
    if featured_actors.count < number_of_top_billed_actors
      get_full_movie_cast[0...number_of_top_billed_actors].each do |tmdb_actor|
        find_or_create_top_billed_actor_from_tmdb(tmdb_actor)
      end
    end
  end

  def find_or_create_top_billed_actor_from_tmdb(tmdb_actor)
    top_actor = Actor.find_or_initialize_by(tmdb_id: tmdb_actor["id"])
    if top_actor.new_record?
      top_actor.update(name: tmdb_actor["name"], image_url: tmdb_actor["profile_path"])
    end
    top_actor.popularity = Tmdb::Person.detail(top_actor.tmdb_id)["popularity"]
    top_actor.save
    Role.find_or_create_by(actor: top_actor, movie: self)
  end

  def get_full_movie_cast
    Tmdb::Movie.casts(tmdb_id)
  end

  private
  def number_of_top_billed_actors
    8
  end
end
