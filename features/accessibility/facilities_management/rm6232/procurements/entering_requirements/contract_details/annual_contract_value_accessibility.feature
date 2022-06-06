@accessibility @javascript
Feature: Annual contract value accessibility

  Scenario: Annual contract value page
    Given I sign in and navigate to my account for 'RM6232'
    And I have an empty procurement for entering requirements named 'My empty procurement'
    When I navigate to the procurement 'My empty procurement'
    Then I am on the 'Further service and contract requirements' page
    And I click on 'Annual contract value'
    And I am on the 'Annual contract value' page
    Then the page should be axe clean