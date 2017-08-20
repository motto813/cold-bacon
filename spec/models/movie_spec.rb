require 'rails_helper'

RSpec.describe Movie, type: :model do

  context "has attributes that pass validation" do
    let(:movie) { Movie.create!(name: "The Rock", tmdb_id: 1, image_url: "profile.jpg") }

    it "creates an movie object" do
      expect(movie).to be_instance_of Movie
    end

    it "has a name" do
      expect(movie.name).to eq "The Rock"
    end

    it "has a movie database api id" do
      expect(movie.tmdb_id).to eq 1
    end

    it "has a image link" do
      expect(movie.image_url).to eq "profile.jpg"
    end

  end

  context "will not pass validations when attributes are not present" do

    it "does not save when name is not present" do
      movie = Movie.new(tmdb_id: 1, image_url: "profile.jpg")
      expect(movie.save).to be false
    end

    it "does not save when movie database api id is not present" do
      movie = Movie.new(name: "The Rock", image_url: "profile.jpg")
      expect(movie.save).to be false
    end

    it "does not save when image link is not present" do
      movie = Movie.new(name: "The Rock", tmdb_id: 1)
      expect(movie.save).to be false
    end

  end

end
