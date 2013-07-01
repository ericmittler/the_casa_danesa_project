class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :uid
      t.string :first_name
      t.string :last_name
      t.string :aka
      t.string :email
      t.boolean :email_validated, :default => false
      t.boolean :event_manager, :default => false

      t.timestamps
    end
  end
end
