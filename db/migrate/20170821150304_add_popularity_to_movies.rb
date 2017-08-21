class AddPopularityToMovies < ActiveRecord::Migration[5.1]
  def change
    add_column :movies, :popularity, :float
  end
end
