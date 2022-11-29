@javascript @accessibility
Feature: Manage users - User admin - Find users - accessibility

  Background: Navigate to manage users page
    Given I sign in as an 'user admin' user go to the crown marketplace dashboard
    When I click on 'Manage users'
    Then I am on the 'Manage users' page
  
  Scenario: Find a user page - No search
    And the page should be axe clean
  
  Scenario: Find a user page - With search
    Given I search for 'test' there are the following users:
      | test1@test.com  | enabled   |
      | test2@test.com  | disabled  |
    And I enter 'test' into the search
    And I click on 'Search'
    Then I should see the following users in the results:
      | test1@test.com  | Enabled   |
      | test2@test.com  | Disabled  |
    And the page should be axe clean
