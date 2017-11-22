class GamesController < ApplicationController
  before_action :clear_paths_and_games, only: [:create, :create_demo]

  def show
    @game = Game.find(params[:id])
    render json: { starting_actor: @game.starting_actor, ending_actor: @game.ending_actor, game_id: @game.id }
  end

  def create
    @game = Game.new
    if @game.save
      redirect_to @game
    else
      render body: nil, status: 400
    end
  end

  def create_demo
    @game = Game.new
    set_demo_starting_actor
    set_demo_ending_actor
    if @game.save
      redirect_to @game
    else
      render body: nil, status: 400
    end
  end

  private
  def clear_paths_and_games
    Path.delete_all
    Game.delete_all
  end

  def set_demo_starting_actor
    @game.starting_actor = Actor.find_or_create_by_tmdb_id(params[:starting_tmdb])
  end

  def set_demo_ending_actor
    @game.ending_actor = Actor.find_or_create_by_tmdb_id(params[:ending_tmdb])
  end
end
