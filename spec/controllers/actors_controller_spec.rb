require 'rails_helper'

RSpec.describe ActorsController, type: :controller do
  describe 'GET #show' do
    let!(:actor) { Actor.create!(name: "Samuel L. Jackson", tmdb_id: 1, image_url: "sam-profile.jpg") }

    # it "responds successfully with an HTTP 204 'no content' status code" do
    #   get :show, params: { id: actor.id }
    #   expect(response).to be_success
    #   expect(response).to have_http_status(204)
    # end

    # it "loads an actor into @actor" do
    #   get :show, params: { id: actor.id }

    #   expect(assigns(:actor)).to eq actor
    # end
  end
end
