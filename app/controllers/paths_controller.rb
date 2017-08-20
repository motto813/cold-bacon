class PathsController < ApplicationController
  def show
    @path = Path.find(params[:id])
    if @path.traceable_type == "Actor"
      @traceables = @path.traceable.get_top_movies
    elsif @path.traceable_type == "Movie"
      @traceables = @path.traceable.get_top_billed_actors
    end
    render json: { game_id: @path.game.id, traceable: @path.traceable, traceables: @traceables }
  end

  def create
    @game = Game.find(params[:game_id])
    @path = Path.new(path_params.merge(game: @game))
    if @path.save
      if path_params["traceable_id"].to_i != @game.ending_actor.id
        redirect_to @path
      else
        redirect_to @game
      end
    else
      render body: nil, status: 400
    end
  end

  private
  def path_params
    params.require(:path).permit(:traceable_type, :traceable_id)
  end
end
