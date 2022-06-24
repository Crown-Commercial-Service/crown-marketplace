@pipeline
Feature: Buildings validations

  Scenario: No buildings selected
    Given I sign in and navigate to my account for 'RM6232'
    And I have buildings
    And I have an empty procurement for entering requirements named 'My buildings procurement'
    When I navigate to the procurement 'My buildings procurement'
    Then I am on the 'Further service and contract requirements' page
    And I click on 'Buildings'
    Then I am on the 'Buildings' page
    And I click on 'Save and return'
    Then I should see the following error messages:
      | Select at least one building  |