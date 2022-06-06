Feature: Contract name

  Background: Navigate to contract name page
    Given I sign in and navigate to my account for 'RM6232'
    And I have an empty procurement for entering requirements named 'My empty procurement'
    When I navigate to the procurement 'My empty procurement'
    Then I am on the 'Further service and contract requirements' page
    And I click on 'Contract name'
    Then I am on the 'Contract name' page

  @pipeline
  Scenario: Change contract name
    And I enter 'My new contract name' into the contract name field
    And I click on 'Save and return'
    Then I am on the 'Further service and contract requirements' page
    And 'Contract name' should have the status 'COMPLETED' in 'Contract details'
    And the procurement name is shown to be 'My new contract name'

  Scenario: The return links work
    Given I click on the 'Return to requirements' return link
    Then I am on the 'Further service and contract requirements' page
    And 'Contract name' should have the status 'COMPLETED' in 'Contract details'
    Then I click on 'Contract name'
    And I am on the 'Contract name' page
    Given I click on 'Return to requirements'
    Then I am on the 'Further service and contract requirements' page
    And 'Contract name' should have the status 'COMPLETED' in 'Contract details'
