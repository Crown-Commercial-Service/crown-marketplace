Feature: Tupe

  Background: Navigate to TUPE page
    Given I sign in and navigate to my account for 'RM6232'
    And I have an empty procurement for entering requirements named 'My empty procurement'
    When I navigate to the procurement 'My empty procurement'
    Then I am on the 'Further service and contract requirements' page
    And I click on 'TUPE'
    And I am on the 'TUPE' page

  Scenario Outline: Both selections are valid
    Given I select '<option>' for TUPE required
    When I click on 'Save and return'
    Then I am on the 'Further service and contract requirements' page
    And 'TUPE' should have the status 'COMPLETED' in 'Contract details'

    Examples:
      | option  |
      | Yes     |
      | No      |

  Scenario: The return links work
    Given I click on the 'Return to requirements' return link
    Then I am on the 'Further service and contract requirements' page
    And 'TUPE' should have the status 'NOT STARTED' in 'Contract details'
    Then I click on 'TUPE'
    And I am on the 'TUPE' page
    Given I click on 'Return to requirements'
    Then I am on the 'Further service and contract requirements' page
    And 'TUPE' should have the status 'NOT STARTED' in 'Contract details'