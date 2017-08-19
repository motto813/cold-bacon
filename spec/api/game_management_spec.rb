require 'rails_helper'

RSpec.describe "Game Management", type: :request do
  context "creates a game that will have actors to choose from" do
    let!(:actor1) { Actor.create!(name: "Sam", tmdb_id: 1, image_url: "sam.jpg") }
    let!(:actor2) { Actor.create!(name: "Jack", tmdb_id: 2, image_url: "jack.jpg") }

    it "creates a game and returns a json object" do
      post "/games"
      expect(response.content_type).to eq("application/json")
      expect(response).to have_http_status(200)
    end

    it "returns a json with a starting and ending actor" do
      post "/games"
      game = JSON.parse(response.body)

      expect(game["starting_actor"]["name"]).to be_a String
      expect(game["ending_actor"]["name"]).to be_a String
    end
  end

  context "creates a game with no actors to choose from" do
    it "returns nothing if game doesn't save" do
      post "/games"
      expect(response.body).to eq ""
      expect(response).to have_http_status(400)
    end
  end
end
