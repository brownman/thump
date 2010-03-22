class CreateLocations < ActiveRecord::Migration
  def self.up
    create_table :locations do |t|
      t.string :full_address, :street_number, :street_name, :street_address, :city, :province, :state, :zip, :country 
      t.float :latitude
      t.float :longitude
      t.timestamps
    end
    add_column :users, :location_id, :integer
  end

  def self.down
    drop_table :locations
    remove_column :users, :location_id
  end
end
