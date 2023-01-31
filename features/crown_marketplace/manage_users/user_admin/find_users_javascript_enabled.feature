@javascript @pipeline
Feature: Manage users - User admin - Find users - JavaScript enabled

  Scenario: Try and find a user
    Given I sign in as an 'user admin' user go to the crown marketplace dashboard
    When I click on 'Manage users'
    Then I am on the 'Manage users' page
    Then I should not see users table
    Given I am going to do a search to find users
    And I search for 'test@' and there are no users
    And I enter 'test@' into the search
    And I click on 'Search'
    And I should see that there are no users with that email address
    Given I search for 'test' there are the following users:
      | test1@test.com  | enabled   |
      | test2@test.com  | disabled  |
    And I enter 'test' into the search
    And I click on 'Search'
    Then I should see the following users in the results:
      | test1@test.com  | Enabled   |
      | test2@test.com  | Disabled  |
