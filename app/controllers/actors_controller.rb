class ActorsController < ApplicationController
  # def index
  #   @movie = Movie.find(params[:movie_id])
  #   @actors = @movie.get_top_billed_actors
  #   render json: @actors
  # end

  def show
    @actor = Actor.find(params[:id])
    render json: @actor
  end
end
