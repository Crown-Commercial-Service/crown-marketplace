@accessibility @javascript
Feature: Buildings

  Background:
    Given I sign in and navigate to my account for 'RM6232'
    And I click on 'Manage my details'
    Then I am on the 'Your details' page

  Scenario: Manage your details page
    Then the page should be axe clean

  Scenario: Manage your details add address
    And I change my contact detail address
    And I enter the following details into the form:
      | Postcode | ST16 1AA |
    And I click on 'Find address'
    And I click on 'Enter address manually, if you can’t find address'
    Then I am on the 'Add address' page
    Then the page should be axe clean
