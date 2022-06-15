Feature: Tupe accessibility

  Scenario: TUPE page
    Given I sign in and navigate to my account for 'RM6232'
    And I have an empty procurement for entering requirements named 'My empty procurement'
    When I navigate to the procurement 'My empty procurement'
    Then I am on the 'Further service and contract requirements' page
    And I click on 'TUPE'
    And I am on the 'TUPE' page