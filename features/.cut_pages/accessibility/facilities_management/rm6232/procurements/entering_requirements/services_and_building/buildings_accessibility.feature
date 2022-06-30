@accessibility @javascript
Feature: Buildings accessibility

  Background: Navigate to the requirements page
    Given I sign in and navigate to my account for 'RM6232'
    And I have an empty procurement for entering requirements named 'My buildings procurement'
    When I navigate to the procurement 'My buildings procurement'
    Then I am on the 'Further service and contract requirements' page

  Scenario: Buildings page without pagination
    Given I have buildings
    And I click on 'Buildings'
    Then I am on the 'Buildings' page
    Then the page should be axe clean

  Scenario:  Buildings page with pagination
    Given I have 200 buildings
    And I click on 'Buildings'
    And I am on the 'Buildings' page
    Then the page should be axe clean

  Scenario: Buildings summary page
    Given I have buildings
    And I click on 'Buildings'
    Then I am on the 'Buildings' page
    And I find and select the following buildings:
      | Test building         |
      | Test London building  |
    And I click on 'Save and return'
    Then I am on the 'Buildings summary' page
    Then the page should be axe clean
