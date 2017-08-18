require 'rails_helper'

RSpec.describe Actor, type: :model do
  context "has attributes that pass validation" do
    let(:actor) { Actor.create!(name: "Bill Murray", tmdb_id: 1, image_url: "profile.jpg") }

    it "has a name" do
      expect(actor.name).to eq "Bill Murray"
    end
  end
end
