class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :login, :email, :crypted_password, :password_salt, :persistence_token, :current_login_ip
      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
