@accessibility @javascript
Feature: Start pages accessibility

  Scenario: Start page
    When I go to the facilities management start page
    Then I am on the 'Find a facilities management supplier' page
    Then the page should be axe clean
  
  Scenario: Sign in page
    When I go to the facilities management start page
    And I am on the 'Find a facilities management supplier' page
    When I click on 'Start now'
    And I click on 'Sign in with Cognito'
    Then I am on the 'Sign in to your account' page
    Then the page should be axe clean

  Scenario: Buyer account page
    Given I sign in and navigate to my account
    Then the page should be axe clean