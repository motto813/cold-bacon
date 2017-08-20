class PathsController < ApplicationController
  def create
    @game = Game.find(params[:game_id])
    @path = Path.new(path_params.merge(game: @game))
    if path_params["traceable_id"].to_i != @game.ending_actor.id
      if @path.save
        redirect_to @path.traceable
      else
        render body: nil, status: 400
      end
    else
      redirect_to @game, status: 302
    end
  end

  private
  def path_params
    params.require(:path).permit(:traceable_type, :traceable_id)
  end
end
