class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.belongs_to :thing
      t.belongs_to :user

      t.timestamps
    end
  end
end
