Feature: Annual contract value

  Background: Navigate to the annual contract value page
    Given I sign in and navigate to my account for 'RM6232'
    And I have an empty procurement for entering requirements named 'My empty procurement'
    When I navigate to the procurement 'My empty procurement'
    Then I am on the 'Further service and contract requirements' page
    And I click on 'Annual contract value'
    And I am on the 'Annual contract value' page

  Scenario: The value is saved
    And I enter '123456' for annual contract value
    And I click on 'Save and return'
    Then I am on the 'Further service and contract requirements' page
    And 'Annual contract value' should have the status 'COMPLETED' in 'Contract details'

  Scenario: The return links work
    Given I click on the 'Return to requirements' return link
    Then I am on the 'Further service and contract requirements' page
    And 'Annual contract value' should have the status 'COMPLETED' in 'Contract details'
    Then I click on 'Annual contract value'
    And I am on the 'Annual contract value' page
    Given I click on 'Return to requirements'
    Then I am on the 'Further service and contract requirements' page
    And 'Annual contract value' should have the status 'COMPLETED' in 'Contract details'