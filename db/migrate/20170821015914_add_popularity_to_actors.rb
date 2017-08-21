class AddPopularityToActors < ActiveRecord::Migration[5.1]
  def change
    add_column :actors, :popularity, :float
  end
end
