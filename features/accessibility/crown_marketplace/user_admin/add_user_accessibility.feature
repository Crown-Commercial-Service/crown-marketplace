@javascript @accessibility
Feature: Manage users - User admin - Add user - accessibility

  Background: Navigate to add user page
    Given I sign in as an 'user admin' user go to the crown marketplace dashboard
    When I click on 'Invite a new user'
    Then I am on the 'Add a user' page
    And the legend is 'Select the role for the user'

  Scenario: Select a role page
    And the page should be axe clean

  Scenario: Select service access page
    Given I choose the 'Service admin' radio button
    Then I click on 'Continue'
    And I am on the 'Add a user' page
    And the legend is 'Select the service access for the user'
    And the page should be axe clean
  
  Scenario: Enter user details page - without telephone number
    Given I choose the 'Buyer' radio button
    Then I click on 'Continue'
    And I am on the 'Add a user' page
    And the legend is 'Select the service access for the user'
    And I select 'Facilities Management'
    Then I click on 'Continue'
    And I am on the 'Add a user' page
    And the page should be axe clean

  Scenario: Enter user details page - with telephone number
    Given I choose the 'Service admin' radio button
    Then I click on 'Continue'
    And I am on the 'Add a user' page
    And the legend is 'Select the service access for the user'
    And I select 'Facilities Management'
    Then I click on 'Continue'
    And I am on the 'Add a user' page
    And the page should be axe clean

  Scenario: Add user page
    Given I choose the 'Service admin' radio button
    Then I click on 'Continue'
    And I am on the 'Add a user' page
    And the legend is 'Select the service access for the user'
    And I select 'Facilities Management'
    Then I click on 'Continue'
    And I am on the 'Add a user' page
    And I do not have an existing user in cognito with email 'name@example.com'
    And I enter the following details into the form:
      | Email address | name@example.com    |
    Then I click on 'Continue'
    And I am on the 'Add a user' page
    And the page should be axe clean
