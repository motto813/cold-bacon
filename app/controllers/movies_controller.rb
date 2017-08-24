class MoviesController < ApplicationController
  def show
    @movie = Movie.find(params[:id])
    render json: @movie
  end
end
