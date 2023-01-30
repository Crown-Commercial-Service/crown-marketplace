@javascript @pipeline
Feature: Manage users - User admin - Find users - JavaScript enabled - Validations

  Background: Navigate to manage users page
    Given I sign in as an 'user admin' user go to the crown marketplace dashboard
    When I click on 'Manage users'
    Then I am on the 'Manage users' page
    Then I should not see users table
    
  Scenario: I enter no email - JavaScript disabled
    And I click on 'Search'
    Then I should see the following error for finding a user:
      | You must enter an email address |
    Then I should not see users table

  Scenario: There is a service error
    And I cannot find any user accounts because of the 'service' error
    And I enter 'test' into the search
    And I click on 'Search'
    Then I should see the following error for finding a user:
      | An error occured: service |
    Then I should not see users table
    
