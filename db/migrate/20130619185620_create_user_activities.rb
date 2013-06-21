class CreateUserActivities < ActiveRecord::Migration
  def change
    create_table :user_activities do |t|
      t.integer :user_id
      t.string :type
      t.string :more_info

      t.timestamps
    end
  end
end
