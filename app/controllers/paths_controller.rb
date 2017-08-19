class PathsController < ApplicationController
  def create
    @game = Game.find(params[:game_id])
    @path = Path.new(path_params.merge(game: @game))
    if @path.save
      redirect_to @path.traceable
    else
      render body: nil, status: 400
    end
  end

  private
  def path_params
    params.require(:path).permit(:traceable_type, :traceable_id)
  end
end
