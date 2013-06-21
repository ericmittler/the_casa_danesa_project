class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :uid
      t.string :name
      t.string :aka
      t.string :email
      t.boolean :event_manager

      t.timestamps
    end
  end
end
