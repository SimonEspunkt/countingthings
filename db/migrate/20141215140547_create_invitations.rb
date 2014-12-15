class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.belongs_to :user
      t.belongs_to :thing
      t.string :recipient_email, null: false
      t.string :confirmation_code, null: false
      t.boolean :accepted, default: false

      t.timestamps
    end
  end
end
