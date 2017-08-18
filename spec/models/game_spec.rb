require 'rails_helper'

RSpec.describe Game, type: :model do
  context "it creates a Game object" do
    let(:game) { Game.create! }

    it "is a Game object" do
      expect(game).to be_instance_of Game
    end

  end

end