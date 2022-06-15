Feature: Buildings used in a procurement are missing a region - validations

  Scenario: No region is selected
    Given I sign in and navigate to my account for 'RM6232'
    And I have a completed procurement for entering requirements named 'My missing regions procurement' with buildings missing regions
    When I navigate to the procurement 'My missing regions procurement'
    Then I am on the 'Review your buildings' page
    Then there are 3 buildings missing a region
    And I select region for 'Test building 1'
    Then I am on the "Confirm your building's region" page
    And I click on 'Save and return'
    Then I should see the following error messages:
      | You must select a region for your address |
