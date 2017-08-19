require 'rails_helper'

RSpec.describe "Game Management", type: :request do
  describe "start a game" do
    context "creates a game that will have actors to choose from" do
      let!(:actor1) { Actor.create!(name: "Sam", tmdb_id: 1, image_url: "sam.jpg") }
      let!(:actor2) { Actor.create!(name: "Jack", tmdb_id: 2, image_url: "jack.jpg") }

      it "returns OK with content type as JSON" do
        post "/games"

        expect(response).to redirect_to assigns(:game)
        expect(response).to have_http_status(302)
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

  describe "shows the game status" do
    let!(:actor1) { Actor.create!(name: "Sam", tmdb_id: 1, image_url: "sam.jpg") }
    let!(:actor2) { Actor.create!(name: "Jack", tmdb_id: 2, image_url: "jack.jpg") }

    context "a game has just been started" do
      it "responds with a JSON object with a starting and ending actor" do
        post "/games"
        get "/games/#{assigns(:game).id}"
        game = JSON.parse(response.body)

        expect(game["starting_actor"]["name"]).to eq("Sam").or(eq("Jack"))
        expect(game["ending_actor"]["name"]).to eq("Sam").or(eq("Jack"))
      end
    end

    context "a game has at least one actor path saved" do
      let!(:game) { Game.create! }
      xit "responds with a JSON object with a path that has an actor" do
        post "/games/#{assigns(:game).id}/paths", params: { actor_id: actor1.id }

        # game = JSON.parse(response.body)

      end
    end
  end

  describe "find an actor's top movies index" do
    context "requests from an actor that has top movies" do
      let!(:actor) { Actor.create!(name: "Bill Murray", tmdb_id: 1, image_url: "bill.jpg") }

      it "returns OK with content type as JSON" do
        VCR.use_cassette "Actor Bill Murray" do
          get "/actors/#{actor.id}/movies"

          expect(response.content_type).to eq("application/json")
          expect(response).to have_http_status(200)
        end
      end

      it "returns a JSON with multiple movies" do
        VCR.use_cassette "Actor Bill Murray" do
          get "/actors/#{actor.id}/movies"

          movies = JSON.parse(response.body)
          expect(movies.length).to be > 0
          movies.each { |movie| expect(movie["title"].length).to be > 0 }
        end
      end
    end
  end

  describe "find a movie's top actors index" do
    let!(:movie) { Movie.create!(title: "The Rock", tmdb_id: 9802, image_url: "the-rock.jpg") }

    context "requests from a movie that has top billed actors" do
      it "returns OK with content type as JSON" do
        VCR.use_cassette "Movie The Rock" do
          get "/movies/#{movie.id}/actors"

          expect(response.content_type).to eq("application/json")
          expect(response).to have_http_status(200)
        end
      end

      it "returns a JSON with multiple actors" do
        VCR.use_cassette "Movie The Rock" do
          get "/movies/#{movie.id}/actors"

          actors = JSON.parse(response.body)
          expect(actors.length).to be > 0
          actors.each { |actor| expect(actor["name"].length).to be > 0 }
        end
      end
    end
  end
end
