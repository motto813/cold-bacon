class CreatePaths < ActiveRecord::Migration[5.1]
  def change
    create_table :paths do |t|
      t.integer :game_id
      t.string :traceable_type
      t.integer :traceable_id

      t.timestamps
    end
  end
end
