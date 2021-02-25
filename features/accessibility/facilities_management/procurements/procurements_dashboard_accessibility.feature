@accessibility @javascript
Feature: Service requirements accessibility

  Background: I am logged in
    Given I sign in and navigate to my account

  Scenario: Procurement dashboard
    And I click on 'Continue a procurement'
    Then I am on the 'Procurements dashboard' page
    Then the page should be axe clean