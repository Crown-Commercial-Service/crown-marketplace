Feature: Select region validations

  Scenario: No services selected
    Given I sign in and navigate to my account for 'RM3830'
    And I click on 'Quick view suppliers'
    Then I am on the 'Services' page
    Then I select the following items:
      | Mechanical and electrical engineering maintenance |
    And I click on 'Continue'
    Then I am on the 'Regions' page
    And I click on 'Continue'
    Then I should see the following error messages:
      | Select at least one region you need to include in your procurement |