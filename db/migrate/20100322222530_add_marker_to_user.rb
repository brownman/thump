class AddMarkerToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :marker_uid, :string
  end

  def self.down
    remove_column :users, :marker_uid
  end
end