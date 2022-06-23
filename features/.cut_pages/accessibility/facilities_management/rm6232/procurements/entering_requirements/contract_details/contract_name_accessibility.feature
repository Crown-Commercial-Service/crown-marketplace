@accessibility @javascript
Feature: Contract name accessibility

  Scenario: Contract name page
    Given I sign in and navigate to my account for 'RM6232'
    And I have an empty procurement for entering requirements named 'My empty procurement'
    When I navigate to the procurement 'My empty procurement'
    Then I am on the 'Further service and contract requirements' page
    And I click on 'Contract name'
    Then I am on the 'Contract name' page
    Then the page should be axe clean