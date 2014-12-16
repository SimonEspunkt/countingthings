class AddOwnerIdToThing < ActiveRecord::Migration
  def change
    add_column :things, :owner_id, :integer
  end
end
