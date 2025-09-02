@accessibility @javascript
Feature: Buyer details - accessibility

  Background: Navigate to Buyer Details page
    Given I sign in without details for 'RM6232'

  Scenario: Buyer details page
    Then the page should be axe clean

  Scenario: Buyer details - add address manually page
    And I enter the following details into the form:
      | Postcode | ST16 1AA |
    And I click on 'Find address'
    And I click on 'Enter address manually, if you can’t find address'
    Then I am on the 'Add address' page
    Then the page should be axe clean
