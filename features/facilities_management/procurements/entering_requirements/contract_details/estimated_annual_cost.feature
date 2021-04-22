Feature: Estimated annual cost

  Background: Navigate to the estimated annual cost page
    Given I sign in and navigate to my account
    And I have an empty procurement for entering requirements named 'My empty procurement'
    When I navigate to the procurement 'My empty procurement'
    Then I am on the 'Requirements' page
    And I click on 'Estimated annual cost'
    And I am on the 'Estimated annual cost' page

  Scenario: No is saved
    Given I select 'No' for estimated annual cost known
    And I click on 'Save and return'
    Then I am on the 'Requirements' page
    And 'Estimated annual cost' should have the status 'COMPLETED' in 'Contract details'

  Scenario: Yes is saved
    Given I select 'Yes' for estimated annual cost known
    And I enter '123456' for estimated annual cost
    And I click on 'Save and return'
    Then I am on the 'Requirements' page
    And 'Estimated annual cost' should have the status 'COMPLETED' in 'Contract details'

  Scenario: The return links work
    Given I click on the 'Return to requirements' return link
    Then I am on the 'Requirements' page
    And 'Estimated annual cost' should have the status 'NOT STARTED' in 'Contract details'
    Then I click on 'Estimated annual cost'
    And I am on the 'Estimated annual cost' page
    Given I click on the 'Return to requirements' back link
    Then I am on the 'Requirements' page
    And 'Estimated annual cost' should have the status 'NOT STARTED' in 'Contract details'