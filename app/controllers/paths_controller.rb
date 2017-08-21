class PathsController < ApplicationController
  include PathsControllerHelper

  def index
    @game = Game.find(params[:game_id])
    @traceables = @game.paths.map { |path| path.traceable }
    render json: @traceables
  end

  def show
    @path = Path.find(params[:id])
    if @path.traceable_type == "Actor"
      @traceables = @path.traceable.get_top_movies
    elsif @path.traceable_type == "Movie"
      @traceables = @path.traceable.get_top_billed_actors
    end
    render json: { game_id: @path.game.id, current_traceable: insert_traceable_type(@path.traceable), possible_paths: include_traceable_type(@traceables) }
  end

  def create
    @game = Game.find(params[:game_id])
    @path = Path.new(path_params.merge(game: @game))
    if @path.save
      unless path_params["traceable_id"].to_i == @game.ending_actor.id && path_params["traceable_type"] == "Actor"
        redirect_to @path
      else
        redirect_to game_paths_path(@game)
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
