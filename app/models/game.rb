class Game < ApplicationRecord
  has_many :paths
  belongs_to :starting_actor, class_name: "Actor"
  belongs_to :ending_actor, class_name: "Actor"

  before_validation :starting_actor, :ending_actor

  def starting_actor
    self.starting_actor = Actor.order("RANDOM()").first
  end

  def ending_actor
    self.ending_actor = Actor.where.not(id: starting_actor.id).order("RANDOM()").first
  end
end
