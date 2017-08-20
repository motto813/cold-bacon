class RenameTitleInMoviesToName < ActiveRecord::Migration[5.1]
  def change
    rename_column :movies, :title, :name
  end
end
