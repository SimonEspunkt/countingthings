class CreateUserobjects < ActiveRecord::Migration
  def change
    create_table :userobjects do |t|
      t.belongs_to :user
      t.belongs_to :thing

      t.timestamps
    end
  end
end
