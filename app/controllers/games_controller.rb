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
    demo_starting_actor = Actor.find_or_initialize_by(tmdb_id: 9778)
    if demo_starting_actor.new_record?
      demo_starting_actor.assign_attributes(name: "Ice Cube", image_url: "/dzdn1tyWkC4EjlBVKvpAhg5osYA.jpg", popularity: 6.46)
      demo_starting_actor.save
    end
    @game.starting_actor = demo_starting_actor
  end

  def set_demo_ending_actor
    demo_ending_actor = Actor.find_or_initialize_by(tmdb_id: 4724)
    if demo_ending_actor.new_record?
      demo_ending_actor.assign_attributes(name: "Kevin Bacon", image_url: "/p1uCaOjxSC1xS5TgmD4uloAkbLd.jpg", popularity: 10000)
      demo_ending_actor.save
    end
    @game.ending_actor = demo_ending_actor
  end
end
