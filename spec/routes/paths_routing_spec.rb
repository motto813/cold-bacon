require "rails_helper"

RSpec.describe "Routing to paths", :type => :routing do

  it "routes GET /games/:game_id/paths to paths#index" do
    expect(:get => "/games/1/paths").to route_to("paths#index", :game_id => "1")
  end

  it "routes GET /paths/1 to paths#show" do
    expect(:get => "/paths/1").to route_to("paths#show", :id => "1")
  end

  it "routes POST /games/:game_id/paths to paths#create" do
    expect(:post => "games/1/paths").to route_to("paths#create", :game_id => "1")
  end

end
