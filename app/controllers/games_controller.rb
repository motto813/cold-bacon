class GamesController < ApplicationController
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
  def set_demo_starting_actor
    @game.starting_actor = Actor.find_or_create_by_tmdb_id(params[:starting_tmdb])
  end

  def set_demo_ending_actor
    @game.ending_actor = Actor.find_or_create_by_tmdb_id(params[:ending_tmdb])
  end
end

# (name: "Kevin Bacon", image_url: "/p1uCaOjxSC1xS5TgmD4uloAkbLd.jpg", popularity: 10000)
