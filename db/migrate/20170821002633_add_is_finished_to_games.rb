class AddIsFinishedToGames < ActiveRecord::Migration[5.1]
  def change
    add_column :games, :is_finished, :boolean, default: false
  end
end
