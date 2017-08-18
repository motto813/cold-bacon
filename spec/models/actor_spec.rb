require 'rails_helper'

RSpec.describe Actor, type: :model do

  context "has attributes that pass validation" do
    let(:actor) { Actor.create!(name: "Bill Murray", tmdb_id: 1, image_url: "profile.jpg") }

    it "creates an Actor object" do
      expect(actor).to be_instance_of Actor
    end

    it "has a name" do
      expect(actor.name).to eq "Bill Murray"
    end

    it "has a movie database api id" do
      expect(actor.tmdb_id).to eq 1
    end

    it "has a image link" do
      expect(actor.image_url).to eq "profile.jpg"
    end
    
  end

  context "will not pass validations when attributes are not present" do

    it "does not save when name is not present" do
      actor = Actor.new(tmdb_id: 1, image_url: "profile.jpg")
      expect(actor.save).to be false
    end

    it "does not save when movie database api id is not present" do
      actor = Actor.new(name: "Bill Murray", image_url: "profile.jpg")
      expect(actor.save).to be false
    end

    it "does not save when image link is not present" do
      actor = Actor.new(name: "Bill Murray", tmdb_id: 1)
      expect(actor.save).to be false
    end

  end

end
