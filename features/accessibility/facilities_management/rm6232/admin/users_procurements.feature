@accessibility @javascript
Feature: User procurements - accessibility

  Background: Admin signs in
    Given I sign in as an admin and navigate to the 'RM6232' dashboard

  Scenario: User procurements page - no procurements
    And I click on 'User procurements'
    Then I am on the 'User procurements' page
    Then the page should be axe clean

  Scenario: User procurements page - multiple procurements
    Given there are 100 procurements
    And I click on 'User procurements'
    Then I am on the 'User procurements' page
    Then the page should be axe clean
