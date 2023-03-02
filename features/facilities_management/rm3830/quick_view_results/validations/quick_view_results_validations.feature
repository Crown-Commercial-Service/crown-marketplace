Feature: Quick view results validations

  Background: Navigate to the Quick view results page
    Given I sign in and navigate to my account for 'RM3830'
    And I click on 'Quick view suppliers'
    Then I am on the 'Services' page
    Then I select the following items:
      | Mechanical and electrical engineering maintenance |
    And I click on 'Continue'
    Then I am on the 'Regions' page
    Then I select the following items:
      | Belfast (UKN01) |
    And I click on 'Continue'
    Then I am on the 'Quick view results' page

  Scenario Outline: Contract name is blank
    Given I click on '<save_button>'
    Then I should see the following error messages:
      | Enter your contract name  |

  Examples:
      | save_button                               |
      | Save and continue to procurement          |
      | Save and return to procurements dashboard |

  Scenario: Contract name is taken
    Given I have a procurement with the name 'Taken contract name'
    And I enter 'Taken contract name' into the contract name field
    And I click on 'Save and continue'
    Then I should see the following error messages:
      | This contract name is already in use  |