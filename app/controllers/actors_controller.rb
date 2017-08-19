class ActorsController < ApplicationController
  def show
    @actor = Actor.find(params[:id])
    render json: @actor
  end

  # def create
  #   @actor
  # end
end
