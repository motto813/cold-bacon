class GamesController < ApplicationController
  def show
  end

  def create
    game = Game.new
    if @game.save
      render json: { starting_actor: starting_actor, ending_actor: ending_actor }
    else
      render nothing: true, status 400
    end
  end
end
