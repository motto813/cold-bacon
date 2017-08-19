class GamesController < ApplicationController
  def show
    @game = Game.find(params[:id])
    render json: { starting_actor: @game.starting_actor, ending_actor: @game.ending_actor, path: @game.paths }
  end

  def create
    @game = Game.new
    if @game.save
      redirect_to @game
    else
      render body: nil, status: 400
    end
  end
end
