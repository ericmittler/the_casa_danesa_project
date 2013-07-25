class CreateEmails < ActiveRecord::Migration
  def change
    create_table :emails do |t|
      t.integer :user_id
      t.string :code
      t.string :address
      t.boolean :confirmed
      t.boolean :primary

      t.timestamps
    end
  end
end
