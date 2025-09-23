Feature: Select region validations

  Scenario: No region selected
    Given I sign in and navigate to my account for 'RM6378'
    And I click on 'Search for suppliers'
    Then I am on the 'Services' page
    Then I select the following items:
      | Mechanical and Electrical Engineering Maintenance |
    And I click on 'Continue'
    Then I am on the 'Regions' page
    And I click on 'Continue'
    Then I should see the following error messages:
      | Select at least one region you need to include in your procurement |
