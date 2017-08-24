require "rails_helper"

RSpec.describe "Routing to games", :type => :routing do

  it "routes GET /games/1 to games#show" do
    expect(:get => "/games/1").to route_to("games#show", :id => "1")
  end

  it "routes POST /games to games#create" do
    expect(:post => "/games").to route_to("games#create")
  end

  it "routes POST /create_demo/:starting_tmdb/:ending_tmdb to games#create_demo" do
    expect(:post => "/create_demo/1/2").to route_to("games#create_demo", :starting_tmdb => "1", :ending_tmdb => "2")
  end

end
