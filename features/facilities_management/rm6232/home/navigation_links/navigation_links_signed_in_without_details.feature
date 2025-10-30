Feature: Navigation links when signed in - without buyer details

  Background: I navigate to manage my details
    Given I sign in without details for 'RM6232'

  Scenario: Buyer details - Sign out
    And I should see the following navigation links:
      | Sign out |
    And I click on 'Sign out'
    And I am on the 'Sign in to your account' page

  Scenario: Buyer details - Manage details - Sign out
    And I click on 'Answer questions (Personal details)'
    Then I am on the 'Manage your personal details' page
    And I should see the following navigation links:
      | Sign out |
    And I click on 'Sign out'
    And I am on the 'Sign in to your account' page
