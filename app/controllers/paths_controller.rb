class PathsController < ApplicationController
  def create
    @game = Game.find(params[:game_id])

  end
end