class CreateAuthenitcationProviders < ActiveRecord::Migration
  def change
    create_table :authenitcation_providers do |t|
      t.string :uid
      t.string :provider_name
      t.string :provided_data
      t.integer :user_id

      t.timestamps
    end
  end
end
