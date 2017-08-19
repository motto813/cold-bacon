class AddEndingActorIdToGames < ActiveRecord::Migration[5.1]
  def change
    add_column :games, :ending_actor_id, :integer
  end
end
