Feature: Authentication
  In order to use the site and manage my own information
  As a user
  I want to be able to signup and login to the site
  
  Scenario: Signup as a new user
    Given I am on the homepage
    And I follow "Signup"
    And I fill in "Username" with "paulbjensen"
    And I fill in "Email" with "paulbjensen@gmail.com"
    And I fill in "Password" with "098765"
    And I fill in "Password Confirmation" with "098765"
    When I press "Signup"
    Then I should be on the signup confirmation page
    And I should receive an email at "paulbjensen@gmail.com"
    And I should see "Thanks for signing up, please click the activation link sent to your email account"
  
  Scenario: Fail to signup as a new user
    Given I am on the homepage
    And I follow "Signup"
    And I fill in "Username" with "paulbjensen"
    And I fill in "Email" with "paulbjensen@gmail.com"
    And I fill in "Password" with "098765"
    And I fill in "Password Confirmation" with "98765"
    When I press "Signup"
    Then I should be on the signup page
    And I should see "There's a problem with the signup information. Please correct and try again."
    
  Scenario: Login as an existing user
    Given there is a user with username "paulbjensen" and password "098765"
    And I am on the homepage
    And I follow "Login"
    And I fill in "Username" with "paulbjensen"
    And I fill in "Password" with "098765"
    When I press "Login"
    Then I should be on the homepage
    And I should see "Hi paulbjensen"
    
  Scenario: Fail to login as an existing user
    Given there is a user with username "paulbjensen" and password "098765"
    And I am on the homepage
    And I follow "Login"
    And I fill in "Username" with "paulbjensen"
    And I fill in "Password" with "98765"
    When I press "Login"
    Then I should be on the login page
    And I should see "There's a problem with the login information. Please correct and try again."
  
  Scenario: Change an existing user's password
    Given I am logged in with username "paulbjensen" and password "098765"
    And I follow "Account"
    And I follow "Change Password"
    And I fill in "Old Password" with "098765"
    And I fill in "New Password" with "012345"
    And I fill in "Confirm New Password" with "012345"
    When I press "Update"
    Then I should be on the account page
    And I should see "Your password was changed"
    
  Scenario: Fail to change an existing user's password
    Given I am logged in with username "paulbjensen" and password "098765"
    And I follow "Account"
    And I follow "Change Password"
    And I fill in "Old Password" with "098765"
    And I fill in "New Password" with "012345"
    And I fill in "Confirm New Password" with ""
    When I press "Update"
    Then I should be on the edit user page
    And I should see "There's a problem with the password information. Please correct and try again."