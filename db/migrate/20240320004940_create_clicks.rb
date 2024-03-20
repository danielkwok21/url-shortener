class CreateClicks < ActiveRecord::Migration[6.0]
  def change
    create_table :clicks do |t|
      t.references :shortened_url, foreign_key: true
      t.string :ip_address
      t.string :user_agent
      t.string :referrer
      t.string :geolocation
      t.string :device_type
      t.string :browser
      t.string :os
      t.string :country

      t.timestamps
    end
  end

  def down
    drop_table :clicks
  end
end
