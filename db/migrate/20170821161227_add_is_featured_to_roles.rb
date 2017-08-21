class AddIsFeaturedToRoles < ActiveRecord::Migration[5.1]
  def change
    add_column :roles, :is_featured, :boolean
  end
end
