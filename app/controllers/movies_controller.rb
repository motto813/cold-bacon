class MoviesController < ApplicationController
  # def index
  #   @actor = Actor.find(params[:actor_id])
  #   @movies = @actor.get_top_movies
  #   render json: @movies
  # end

  def show
    @movie = Movie.find(params[:id])
  end
end
