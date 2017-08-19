class ActorsController < ApplicationController
  # def index
  #   @movie = Movie.find(params[:movie_id])

  # end

  def show
    @actor = Actor.find(params[:id])
    render json: @actor
  end
end
