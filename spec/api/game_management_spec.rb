require 'rails_helper'

RSpec.describe "Game Management", type: :request do
  describe "creating a game" do
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

  describe "showing a game" do
    let!(:actor1) { Actor.create!(name: "Sam", tmdb_id: 1, image_url: "sam.jpg") }
    let!(:actor2) { Actor.create!(name: "Jack", tmdb_id: 2, image_url: "jack.jpg") }
    let!(:movie) { Movie.create!(name: "The Rock", tmdb_id: 1, image_url: "profile.jpg") }

    context "a game has just been started" do
      it "responds with a JSON object with a starting and ending actor" do
        post "/games"
        get "/games/#{assigns(:game).id}"
        game = JSON.parse(response.body)

        expect(game["starting_actor"]["name"]).to eq("Sam").or(eq("Jack"))
        expect(game["ending_actor"]["name"]).to eq("Sam").or(eq("Jack"))
      end
    end
  end

  describe "creating a path" do
    let!(:actor1) { Actor.create!(name: "Sam", tmdb_id: 1, image_url: "sam.jpg") }
    let!(:actor2) { Actor.create!(name: "Jack", tmdb_id: 2, image_url: "jack.jpg") }
    let!(:movie) { Movie.create!(name: "The Rock", tmdb_id: 1, image_url: "profile.jpg") }
    let!(:game) { Game.create! }

    context "a non-winning path is chosen" do
      it "redirects to show path if an traceable path is created" do
        actor3 = Actor.create!(name: "Paul", tmdb_id: 3, image_url: "paul.jpg")

        post "/games/#{game.id}/paths", params: { path: { traceable_type: "Actor", traceable_id: actor3.id } }

        expect(response).to redirect_to assigns(:path)
        expect(response).to have_http_status(302)
      end

      it "returns a response from the show path with current game, current traceable, and possible paths" do
        VCR.use_cassette "Actor Bill Murray" do
          actor3 = Actor.create!(name: "Bill Murray", tmdb_id: 3, image_url: "bill.jpg")
          role = Role.create!(actor: actor3, movie: movie)

          post "/games/#{game.id}/paths", params: { path: { traceable_type: "Actor", traceable_id: actor3.id } }
          get "/paths/#{assigns(:path).id}"

          path_response = JSON.parse(response.body)

          expect(path_response["game_id"]).to eq game.id
          expect(path_response["current_traceable"]["traceable"]["id"]).to eq actor3.id
          expect(path_response["possible_paths"][0]["traceable_type"]).to eq movie.class.to_s
          expect(path_response["possible_paths"][0]["traceable"]["id"]).to eq movie.id
        end
      end
    end

    context "a winning path is chosen" do
      let!(:game) { Game.create! }

      it "redirect to paths index and send status code" do
        post "/games/#{game.id}/paths", params: { path: { traceable_type: "Actor", traceable_id: game.ending_actor.id } }

        expect(response).to redirect_to game_paths_path(game)
        expect(response).to have_http_status(302)
      end

      it "responds with a property showing that the game is finished" do
        post "/games/#{game.id}/paths", params: { path: { traceable_type: "Actor", traceable_id: game.ending_actor.id } }

        get "/games/#{game.id}/paths"
        paths_response = JSON.parse(response.body)

        expect(paths_response["game_is_finished"]).to eq true
      end

      it "responds with traceables that include starting and ending actor" do
        post "/games/#{game.id}/paths", params: { path: { traceable_type: "Actor", traceable_id: game.starting_actor.id } }
        post "/games/#{game.id}/paths", params: { path: { traceable_type: "Actor", traceable_id: game.ending_actor.id } }

        get "/games/#{game.id}/paths"
        paths_response = JSON.parse(response.body)

        expect(paths_response["paths_chosen"].first["id"]).to eq game.starting_actor.id
        expect(paths_response["paths_chosen"].last["id"]).to eq game.ending_actor.id
      end
    end
  end

  describe "path index" do
    let!(:actor1) { Actor.create!(name: "Sam", tmdb_id: 1, image_url: "sam.jpg") }
    let!(:actor2) { Actor.create!(name: "Jack", tmdb_id: 2, image_url: "jack.jpg") }
    let!(:movie) { Movie.create!(name: "The Rock", tmdb_id: 1, image_url: "profile.jpg") }

    context "a game has at least one actor path saved" do
      let!(:game) { Game.create! }

      it "responds with a JSON object with a path that has an actor" do
        actor3 = Actor.create!(name: "Paul", tmdb_id: 3, image_url: "paul.jpg")

        post "/games/#{game.id}/paths", params: { path: { traceable_type: "Actor", traceable_id: actor3.id } }

        get "/games/#{game.id}/paths"
        paths_response = JSON.parse(response.body)

        # expect(paths_response["paths"].first["traceable_type"]).to eq "Actor"
        expect(paths_response["paths_chosen"].first["id"]).to eq actor3.id
      end
    end

    context "a game has at least one movie path saved" do
      let!(:game) { Game.create! }

      it "responds with a JSON object with a path that has a movie" do
        post "/games/#{game.id}/paths", params: { path: { traceable_type: "Movie", traceable_id: movie.id } }

        get "/games/#{game.id}/paths"
        paths_response = JSON.parse(response.body)

        # expect(paths_response["paths"].first["traceable_type"]).to eq "Movie"
        expect(paths_response["paths_chosen"].first["id"]).to eq movie.id
      end
    end
  end
end
