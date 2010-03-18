Given /^I am logged in with login "([^\"]*)" and password "([^\"]*)"$/ do |login, password|
  Given %(a user exists with login: "#{login}", email: "paulbjensen@gmail.com", password: "#{password}", password_confirmation: "#{password}")
  Given %(I am on the homepage)
  Given %(I follow "Login")
  Given %(I fill in "Username/Email" with "#{login}")
  Given %(I fill in "Password" with "#{password}")
  Given %(I press "login")
end