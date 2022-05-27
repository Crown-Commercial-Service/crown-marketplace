@accessibility @javascript
Feature: Service requirements accessibility

  Scenario: Procurement dashboard
    Given I sign in and navigate to my account for 'RM6232'
    And I click on 'Continue a procurement'
    Then I am on the 'Procurements dashboard' page
    Then the page should be axe clean