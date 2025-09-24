@accessibility @javascript
Feature: Service requirements accessibility

  Scenario: Procurement dashboard
    Given I sign in and navigate to my account for 'RM6232'
    And I click on 'View your saved searches'
    Then I am on the 'Saved searches' page
    Then the page should be axe clean
