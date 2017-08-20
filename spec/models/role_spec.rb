require 'rails_helper'

RSpec.describe Role, type: :model do

   context "has attributes that pass validation" do
    let(:actor) { Actor.create!(name: "Bill Murray", tmdb_id: 1, image_url: "profile.jpg") }
    let(:movie) { Movie.create!(name: "The Rock", tmdb_id: 1, image_url: "profile.jpg") }
    let(:role) { Role.create!(actor: actor, movie: movie) }

    it "is a Role object" do
      expect(role).to be_instance_of Role
    end

    it "has an actor" do
      expect(role.actor).to be_instance_of Actor
    end

    it "has an actor with a name" do
      expect(role.actor.name).to eq "Bill Murray"
    end

    it "has a movie" do
      expect(role.movie).to be_instance_of Movie
    end

    it "has a movie with a name" do
      expect(role.movie.name).to eq "The Rock"
    end

  end

  context "will not pass validations when attributes are not present" do
    let(:actor) { Actor.create!(name: "Bill Murray", tmdb_id: 1, image_url: "profile.jpg") }
    let(:movie) { Movie.create!(name: "The Rock", tmdb_id: 1, image_url: "profile.jpg") }

    it "does not save when name is not present" do
      role = Role.new(actor: actor)
      expect(role.save).to be false
    end

    it "does not save when movie database api id is not present" do
      role = Role.new(movie: movie)
      expect(role.save).to be false
    end

  end

end
