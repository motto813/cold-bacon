require 'rails_helper'

RSpec.describe Game, type: :model do
  context "it creates a Game object" do
    let!(:actor1) { Actor.create!(name: "Sam", tmdb_id: 1, image_url: "sam.jpg") }
    let!(:actor2) { Actor.create!(name: "Jack", tmdb_id: 2, image_url: "jack.jpg") }

    let(:game) { Game.create! }

    it "is a Game object" do
      expect(game).to be_instance_of Game
    end

    it "has a starting actor" do
      expect(game.starting_actor).to be_instance_of Actor
    end

    it "has an ending actor" do
      expect(game.ending_actor).to be_instance_of Actor
    end
  end
end
