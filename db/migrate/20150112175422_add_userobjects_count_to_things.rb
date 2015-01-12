class AddUserobjectsCountToThings < ActiveRecord::Migration
  def change
    add_column :things, :userobjects_count, :integer
  end
end
