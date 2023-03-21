Feature: Contract name

  Background: Navigate to contract name page
    Given I sign in and navigate to my account for 'RM3830'
    And I have an empty procurement for entering requirements named 'My empty procurement'
    When I navigate to the procurement 'My empty procurement'
    Then I am on the 'Requirements' page
    And I click on 'Contract name'
    Then I am on the 'Contract name' page

  Scenario: Change contract name
    And I enter 'My new contract name' into the contract name field
    And I click on 'Save and return'
    Then I am on the 'Requirements' page
    And 'Contract name' should have the status 'COMPLETED' in 'Contract details'
    And I should see my name is 'My new contract name'

  Scenario: The return links work
    Given I click on the 'Return to requirements' return link
    Then I am on the 'Requirements' page
    And 'Contract name' should have the status 'COMPLETED' in 'Contract details'
