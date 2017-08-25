require 'rails_helper'

# Kevin Bacon tmdb_id: 4724
# Ice Cube tmdb_id: 9778

RSpec.describe "Game Management", type: :request do
  describe "creating a game" do
    context "creates a game that will have actors to choose from" do
      let!(:actor1) { Actor.create!(name: "Sam", tmdb_id: 1, image_url: "sam.jpg", popularity: 60) }
      let!(:actor2) { Actor.create!(name: "Jack", tmdb_id: 2, image_url: "jack.jpg", popularity: 60) }
      let!(:movie) { Movie.create!(name: "The Rock", tmdb_id: 1, image_url: "profile.jpg", popularity: 60) }

      it "returns OK with content type as JSON" do
        post "/games"

        expect(response).to redirect_to assigns(:game)
        expect(response).to have_http_status(302)
      end

      it "responds with a JSON object with a starting and ending actor" do
        post "/games"
        get "/games/#{assigns(:game).id}"
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

  describe "creating a demo game" do
    let(:starting_tmdb) { 9778 }
    let(:ending_tmdb) { 4724 }

    context "sending valid params in the url" do
      it "returns OK with content type as JSON" do
        VCR.use_cassette "Demo Game Actors" do
          post "/create_demo/#{starting_tmdb}/#{ending_tmdb}"

          expect(response).to redirect_to assigns(:game)
          expect(response).to have_http_status(302)
        end
      end

      it "responds with the requested starting and ending actor" do
        VCR.use_cassette "Demo Game Actors" do
          post "/create_demo/#{starting_tmdb}/#{ending_tmdb}"
          get "/games/#{assigns(:game).id}"
          game_response = JSON.parse(response.body)

          expect(game_response["starting_actor"]["tmdb_id"]).to eq starting_tmdb
          expect(game_response["ending_actor"]["tmdb_id"]).to eq ending_tmdb
        end
      end
    end

    context "sending invalid params in the url" do
      it "returns nothing with a status of 400" do
        VCR.use_cassette "Invalid TMDB Ids" do
          post "/create_demo/not_an_int/non_an_int"

          expect(response.body).to eq ""
          expect(response).to have_http_status(400)
        end
      end
    end
  end

  describe "creating a path" do
    let!(:actor1) { Actor.create!(name: "Sam", tmdb_id: 1, image_url: "sam.jpg", popularity: 60) }
    let!(:actor2) { Actor.create!(name: "Jack", tmdb_id: 2, image_url: "jack.jpg", popularity: 60) }
    let!(:game) { Game.create! }

    let(:possible_paths_count) { 8 }

    context "the request includes a non-existent traceable" do
      it "returns nothing with a status of 400" do
        post "/games/#{game.id}/paths", params: { path: { traceable_type: "Actor", traceable_id: 0 } }

        expect(response.body).to eq ""
        expect(response).to have_http_status(400)
      end
    end

    context "a non-winning path is chosen" do
      it "redirects to show path if an traceable path is created" do
        VCR.use_cassette "Actor Bill Murray" do
          actor3 = Actor.create!(name: "Bill Murray", tmdb_id: 1532, image_url: "profile.jpg", popularity: 60)

          post "/games/#{game.id}/paths", params: { path: { traceable_type: "Actor", traceable_id: actor3.id } }

          expect(response).to redirect_to assigns(:path)
          expect(response).to have_http_status(302)
        end
      end

      it "returns a response with the current game and the traceable used" do
        VCR.use_cassette "Actor Bill Murray" do
          actor3 = Actor.create!(name: "Bill Murray", tmdb_id: 1532, image_url: "profile.jpg", popularity: 60)

          post "/games/#{game.id}/paths", params: { path: { traceable_type: "Actor", traceable_id: actor3.id } }
          get "/paths/#{assigns(:path).id}"

          path_response = JSON.parse(response.body)

          expect(path_response["game_id"]).to eq game.id
          expect(path_response["current_traceable"]["traceable"]["id"]).to eq actor3.id
        end
      end

      it "returns a response for a created actor path with the correct number of unique possible movie paths" do
        VCR.use_cassette "Actor Bill Murray" do
          actor3 = Actor.create!(name: "Bill Murray", tmdb_id: 1532, image_url: "profile.jpg", popularity: 60)

          post "/games/#{game.id}/paths", params: { path: { traceable_type: "Actor", traceable_id: actor3.id } }
          get "/paths/#{assigns(:path).id}"

          path_response = JSON.parse(response.body)

          expect(path_response["possible_paths"].length).to eq possible_paths_count
          expect(path_response["possible_paths"].uniq.length).to eq path_response["possible_paths"].length
          path_response["possible_paths"].each do |path|
            expect(path["traceable_type"]).to eq "Movie"
          end
        end
      end

      context "creating a path for an actor with popular known for movies" do
        it "returns a response with the correct number of unique possible movie paths" do
          VCR.use_cassette "Actor Chris Pratt" do
            actor3 = Actor.create!(name: "Chris Pratt", tmdb_id: 73457, image_url: "profile.jpg", popularity: 60)

            post "/games/#{game.id}/paths", params: { path: { traceable_type: "Actor", traceable_id: actor3.id } }
            get "/paths/#{assigns(:path).id}"

            path_response = JSON.parse(response.body)

            expect(path_response["possible_paths"].length).to eq possible_paths_count
            expect(path_response["possible_paths"].uniq.length).to eq path_response["possible_paths"].length
            path_response["possible_paths"].each do |path|
              expect(path["traceable_type"]).to eq "Movie"
            end
          end
        end
      end

      it "returns a response for a created movie path with correct number of unique possible actor paths" do
        VCR.use_cassette "Movie The Rock" do
          movie = Movie.create!(name: "The Rock", tmdb_id: 9802, image_url: "profile.jpg", popularity: 60)

          post "/games/#{game.id}/paths", params: { path: { traceable_type: "Movie", traceable_id: movie.id } }
          get "/paths/#{assigns(:path).id}"

          path_response = JSON.parse(response.body)

          expect(path_response["possible_paths"].length).to eq possible_paths_count
          expect(path_response["possible_paths"].uniq.length).to eq path_response["possible_paths"].length
          path_response["possible_paths"].each do |path|
            expect(path["traceable_type"]).to eq "Actor"
          end
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

  describe "showing an actor" do
    let!(:actor) { Actor.create!(name: "Sam", tmdb_id: 1, image_url: "sam.jpg", popularity: 60) }

    it "responds OK with the correct actor object" do
      get "/actors/#{actor.id}"
      actor_response = JSON.parse(response.body)

      expect(response).to have_http_status(200)
      expect(actor_response["id"]).to eq actor.id
    end
  end

  describe "showing a movie" do
    let!(:movie) { Movie.create!(name: "The Rock", tmdb_id: 1, image_url: "profile.jpg", popularity: 60) }

    it "responds OK with the correct movie object" do
      get "/movies/#{movie.id}"
      movie_response = JSON.parse(response.body)

      expect(response).to have_http_status(200)
      expect(movie_response["id"]).to eq movie.id
    end
  end

  describe "path index" do
    let!(:actor1) { Actor.create!(name: "Sam", tmdb_id: 1, image_url: "sam.jpg", popularity: 60) }
    let!(:actor2) { Actor.create!(name: "Jack", tmdb_id: 2, image_url: "jack.jpg", popularity: 60) }
    let!(:movie) { Movie.create!(name: "The Rock", tmdb_id: 0, image_url: "profile.jpg", popularity: 60) }
    let!(:game) { Game.create! }

    it "responds OK" do
      get "/games/#{game.id}/paths"

      expect(response).to have_http_status(200)
    end

    context "a game has at least one actor path saved" do
      it "responds with a JSON object with a path that has an actor" do
        actor3 = Actor.create!(name: "Paul", tmdb_id: 3, image_url: "paul.jpg", popularity: 60)

        post "/games/#{game.id}/paths", params: { path: { traceable_type: "Actor", traceable_id: actor3.id } }

        get "/games/#{game.id}/paths"
        paths_response = JSON.parse(response.body)

        expect(paths_response["paths_chosen"].first["id"]).to eq actor3.id
      end
    end

    context "a game has at least one movie path saved" do
      it "responds with a JSON object with a path that has a movie" do
        post "/games/#{game.id}/paths", params: { path: { traceable_type: "Movie", traceable_id: movie.id } }

        get "/games/#{game.id}/paths"
        paths_response = JSON.parse(response.body)

        expect(paths_response["paths_chosen"].first["id"]).to eq movie.id
      end
    end
  end
end
