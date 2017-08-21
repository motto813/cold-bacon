class RenameIsFeaturedInRolesToIsKnownFor < ActiveRecord::Migration[5.1]
  def change
    rename_column :roles, :is_featured, :is_known_for
  end
end
