# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

dummy_users = User.create(
  [
    {:login => 'paulbjensen', :email => 'paulbjensen@gmail.com', :password => '098765', :password_confirmation => '098765'}, 
    {:login => 'paulnewbamboo', :email => 'paul@new-bamboo.co.uk', :password => '098765', :password_confirmation => '098765'}, 
  ]
)