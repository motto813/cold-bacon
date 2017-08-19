class GamesController < ApplicationController
  def show
  end

  def create
    game = Game.new
    if game.save
      render json: { starting_actor: game.starting_actor, ending_actor: game.ending_actor }
    else
      render nothing: true, status: 400
    end
  end
end
