@accessibility @javascript
Feature: Service requirements accessibility

  Background: Navigate to what happens next
    Given I sign in and navigate to my account
    And I click on 'Start a procurement'
    Then I am on the 'What happens next' page

  Scenario: What happens next page
    Then the page should be axe clean

  Scenario: Create a procurement page
    And I click on 'Continue'
    Then I am on the 'Contract name' page
    Then the page should be axe clean