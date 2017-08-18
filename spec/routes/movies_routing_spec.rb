require "rails_helper"

RSpec.describe "Routing to movies", :type => :routing do

  it "routes GET /movies/1 to movies#show" do
    expect(:get => "/movies/1").to route_to("movies#show", :id => "1")
  end

end
