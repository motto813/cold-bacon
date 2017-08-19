require 'rails_helper'

RSpec.describe "Game Management", type: :request do
  describe "start a game" do
    context "creates a game that will have actors to choose from" do
      let!(:actor1) { Actor.create!(name: "Sam", tmdb_id: 1, image_url: "sam.jpg") }
      let!(:actor2) { Actor.create!(name: "Jack", tmdb_id: 2, image_url: "jack.jpg") }

      it "returns OK with content type as JSON" do
        post "/games"

        expect(response.content_type).to eq("application/json")
        expect(response).to have_http_status(200)
      end

      it "returns a json with a starting and ending actor" do
        post "/games"
        game = JSON.parse(response.body)

        expect(game["starting_actor"]["name"]).to eq("Sam").or(eq("Jack"))
        expect(game["ending_actor"]["name"]).to eq("Sam").or(eq("Jack"))
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

  describe "find an actor's top movies index" do
    context "requests from an actor with top movies" do
      let!(:actor) { Actor.create!(name: "Bill Murray", tmdb_id: 1, image_url: "bill.jpg") }

      it "returns OK with content type as JSON" do
        VCR.use_cassette "Actor Bill Murray" do
          get "/actors/#{actor.id}/movies"

          expect(response.content_type).to eq("application/json")
          expect(response).to have_http_status(200)
        end
      end

      it "returns a JSON with movies" do
        VCR.use_cassette "Actor Bill Murray" do
          get "/actors/#{actor.id}/movies"

          movies = JSON.parse(response.body)
          movies.each { |movie| expect(movie["title"].length).to be > 0 }
        end
      end
    end
  end
end
