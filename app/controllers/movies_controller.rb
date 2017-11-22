class MoviesController < ApplicationController
  def index
    @actor = Actor.find(params[:actor_id])
    render json: @actor.most_relevant_movies
  end

  def known_for_movies
    @actor = Actor.find(params[:actor_id])
    render json: @actor.find_or_create_known_for_movies.order("RANDOM()")
  end

  def show
    @movie = Movie.find(params[:id])
    render json: @movie
  end
end
