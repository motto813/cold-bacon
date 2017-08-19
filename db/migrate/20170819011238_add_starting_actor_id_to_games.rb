class AddStartingActorIdToGames < ActiveRecord::Migration[5.1]
  def change
    add_column :games, :starting_actor_id, :integer
  end
end
