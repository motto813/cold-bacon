class CreateActors < ActiveRecord::Migration[5.1]
  def change
    create_table :actors do |t|
      t.string :name
      t.integer :tmdb_id
      t.string :image_url

      t.timestamps
    end
  end
end
