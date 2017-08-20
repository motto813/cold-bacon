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

    context "a game has at least one actor path saved" do
      let!(:game) { Game.create! }

      it "saves an actor path and responds with a JSON object with a path that has an actor" do
        actor3 = Actor.create!(name: "Paul", tmdb_id: 3, image_url: "paul.jpg")

        post "/games/#{game.id}/paths", params: { path: { traceable_type: "Actor", traceable_id: actor3.id } }

        get "/games/#{assigns(:game).id}"
        game = JSON.parse(response.body)

        expect(game["paths"].first["traceable_type"]).to eq "Actor"
        expect(game["paths"].first["traceable_id"]).to eq actor3.id
      end
    end

    context "a game has at least one movie path saved" do
      let!(:game) { Game.create! }

      it "saves an movie path and responds with a JSON object with a path that has a movie" do
        post "/games/#{game.id}/paths", params: { path: { traceable_type: "Movie", traceable_id: movie.id } }

        get "/games/#{assigns(:game).id}"
        game = JSON.parse(response.body)

        expect(game["paths"].first["traceable_type"]).to eq "Movie"
        expect(game["paths"].first["traceable_id"]).to eq movie.id
      end
    end

    context "a game is won" do
      let!(:game) { Game.create! }

      it "redirect to finished game and send status code" do
        post "/games/#{game.id}/paths", params: { path: { traceable_type: "Actor", traceable_id: game.ending_actor.id } }

        expect(response).to redirect_to game
        expect(response).to have_http_status(302)
      end

      it "creates a path if winning move is made" do
        post "/games/#{game.id}/paths", params: { path: { traceable_type: "Actor", traceable_id: game.ending_actor.id } }

        get "/games/#{assigns(:game).id}"
        game_response = JSON.parse(response.body)

        expect(game_response["paths"][0]["traceable_id"]).to eq game.ending_actor.id
        expect(game_response["paths"][0]["game_id"]).to eq game.id
      end

      it "returns a path with an actor that a path has been created for and for the correct game" do
        actor3 = Actor.create!(name: "Paul", tmdb_id: 3, image_url: "paul.jpg")

        post "/games/#{game.id}/paths", params: { path: { traceable_type: "Actor", traceable_id: actor3.id } }
        post "/games/#{game.id}/paths", params: { path: { traceable_type: "Actor", traceable_id: game.ending_actor.id } }

        get "/games/#{assigns(:game).id}"
        game_response = JSON.parse(response.body)

        expect(game_response["paths"][0]["traceable_id"]).to eq actor3.id
        expect(game_response["paths"][0]["game_id"]).to eq game.id
      end
    end

  end

  describe "creating a path" do
    let!(:actor1) { Actor.create!(name: "Sam", tmdb_id: 1, image_url: "sam.jpg") }
    let!(:actor2) { Actor.create!(name: "Jack", tmdb_id: 2, image_url: "jack.jpg") }
    let!(:movie) { Movie.create!(name: "The Rock", tmdb_id: 1, image_url: "profile.jpg") }
    let!(:game) { Game.create! }

    it "redirects to show path if an traceable path is created" do
      actor3 = Actor.create!(name: "Paul", tmdb_id: 3, image_url: "paul.jpg")

      post "/games/#{game.id}/paths", params: { path: { traceable_type: "Actor", traceable_id: actor3.id } }

      expect(response).to redirect_to assigns(:path)
      expect(response).to have_http_status(302)
    end

    it "returns a response with the show path" do
      VCR.use_cassette "Actor Bill Murray" do
        actor3 = Actor.create!(name: "Bill Murray", tmdb_id: 3, image_url: "bill.jpg")

        post "/games/#{game.id}/paths", params: { path: { traceable_type: "Actor", traceable_id: actor3.id } }
        get "/paths/#{assigns(:path).id}"

        p path_response = JSON.parse(response.body)

        expect(path_response["game_id"]).to eq game.id
        expect(path_response["traceable"]["id"]).to eq actor3.id
      end
    end
  end

  # describe "finding an actor's top movies index" do
  #   context "requests from an actor that has top movies" do
  #     let!(:actor) { Actor.create!(name: "Bill Murray", tmdb_id: 1, image_url: "bill.jpg") }

  #     it "returns OK with content type as JSON" do
  #       VCR.use_cassette "Actor Bill Murray" do
  #         get "/actors/#{actor.id}/movies"

  #         expect(response.content_type).to eq("application/json")
  #         expect(response).to have_http_status(200)
  #       end
  #     end

  #     it "returns a JSON with multiple movies" do
  #       VCR.use_cassette "Actor Bill Murray" do
  #         get "/actors/#{actor.id}/movies"

  #         movies = JSON.parse(response.body)
  #         expect(movies.length).to be > 0
  #         movies.each { |movie| expect(movie["name"].length).to be > 0 }
  #       end
  #     end
  #   end
  # end

  # describe "finding a movie's top actors index" do
  #   let!(:movie) { Movie.create!(name: "The Rock", tmdb_id: 9802, image_url: "the-rock.jpg") }

  #   context "requests from a movie that has top billed actors" do
  #     it "returns OK with content type as JSON" do
  #       VCR.use_cassette "Movie The Rock" do
  #         get "/movies/#{movie.id}/actors"

  #         expect(response.content_type).to eq("application/json")
  #         expect(response).to have_http_status(200)
  #       end
  #     end

  #     it "returns a JSON with multiple actors" do
  #       VCR.use_cassette "Movie The Rock" do
  #         get "/movies/#{movie.id}/actors"

  #         actors = JSON.parse(response.body)
  #         expect(actors.length).to be > 0
  #         actors.each { |actor| expect(actor["name"].length).to be > 0 }
  #       end
  #     end
  #   end
  # end
end
