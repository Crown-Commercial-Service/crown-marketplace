@accessibility @javascript
Feature: Services accessibility

  Background: Navigate to the service page
    Given I sign in and navigate to my account for 'RM6232'
    And I have an empty procurement for entering requirements named 'My services procurement'
    When I navigate to the procurement 'My services procurement'
    Then I am on the 'Further service and contract requirements' page
    And I click on 'Services'
    Then I am on the 'Services summary' page

  Scenario: Services summary page
    Then the page should be axe clean

  Scenario: Services page
    Given I click on 'Change'
    Then I am on the 'Services' page
    And the page should be axe clean