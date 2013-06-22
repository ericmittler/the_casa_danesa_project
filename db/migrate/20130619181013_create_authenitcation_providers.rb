class CreateAuthenitcationProviders < ActiveRecord::Migration
  def change
    create_table :authenitcation_providers do |t|
      t.string :provider
      t.string :uid
      t.text :info
      t.text :extra
      t.integer :user_id

      t.timestamps
    end
  end
end
