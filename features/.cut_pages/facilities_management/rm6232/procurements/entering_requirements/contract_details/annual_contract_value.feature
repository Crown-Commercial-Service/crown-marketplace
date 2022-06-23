Feature: Annual contract cost

  Background: Navigate to the annual contract cost page
    Given I sign in and navigate to my account for 'RM6232'
    And I have an empty procurement for entering requirements named 'My empty procurement'
    When I navigate to the procurement 'My empty procurement'
    Then I am on the 'Further service and contract requirements' page
    And I click on 'Annual contract cost'
    And I am on the 'Annual contract cost' page

  Scenario: The value is saved
    And I enter '123456' for annual contract cost
    And I click on 'Save and return'
    Then I am on the 'Further service and contract requirements' page
    And 'Annual contract cost' should have the status 'COMPLETED' in 'Contract details'

  Scenario: The return links work
    Given I click on the 'Return to requirements' return link
    Then I am on the 'Further service and contract requirements' page
    And 'Annual contract cost' should have the status 'COMPLETED' in 'Contract details'
    Then I click on 'Annual contract cost'
    And I am on the 'Annual contract cost' page
    Given I click on 'Return to requirements'
    Then I am on the 'Further service and contract requirements' page
    And 'Annual contract cost' should have the status 'COMPLETED' in 'Contract details'