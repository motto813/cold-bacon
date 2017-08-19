class Game < ApplicationRecord
  has_many :paths
  belongs_to :starting_actor, class_name: "Actor"
  belongs_to :ending_actor, class_name: "Actor"

  before_validation :set_starting_actor, :set_ending_actor

  def set_starting_actor
    self.starting_actor = Actor.order("RANDOM()").first
  end

  def set_ending_actor
    self.ending_actor = Actor.where.not(id: starting_actor.id).order("RANDOM()").first
  end
end
