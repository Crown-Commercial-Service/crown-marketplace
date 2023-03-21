Feature: Select services validations

  Scenario: No services selected
    Given I sign in and navigate to my account for 'RM3830'
    And I click on 'Quick view suppliers'
    Then I am on the 'Services' page
    And I click on 'Continue'
    Then I should see the following error messages:
      | Select at least one service you need to include in your procurement |
