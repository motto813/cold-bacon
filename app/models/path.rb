class Path < ApplicationRecord
  belongs_to :game
  belongs_to :traceable, polymorphic: true

  validates_presence_of :game, :traceable
end
