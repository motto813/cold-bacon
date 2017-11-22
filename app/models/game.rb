class Game < ApplicationRecord
  has_many :paths
  belongs_to :starting_actor, class_name: "Actor"
  belongs_to :ending_actor, class_name: "Actor"

  validates_presence_of :starting_actor, :ending_actor

  before_validation :set_starting_actor, :set_ending_actor

  def set_starting_actor
    self.starting_actor ||= Actor.random_qualified_starting_actors.first
  end

  def set_ending_actor
    self.ending_actor ||= Actor.random_qualified_starting_actors.where.not(id: starting_actor.id).first if starting_actor
  end
end
