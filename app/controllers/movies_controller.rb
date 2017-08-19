class MoviesController < ApplicationController
  def index
    @actor = Actor.find(params[:actor_id])
    @movies = @actor.top_movies
  end

  def show
    @movie = Movie.find(params[:id])
  end
end
