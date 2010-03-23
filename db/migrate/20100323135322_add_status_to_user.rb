class AddStatusToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :message, :string
  end

  def self.down
    remove_column :users, :message
  end
end
