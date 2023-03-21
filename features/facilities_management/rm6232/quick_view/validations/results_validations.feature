Feature: Results validations

  Background: Navigate to the Results page
    Given I sign in and navigate to my account for 'RM6232'
    And I click on 'Search for suppliers'
    Then I am on the 'Services' page
    Then I select the following items:
      | Mechanical and Electrical Engineering Maintenance           |
    And I click on 'Continue'
    Then I am on the 'Regions' page
    Then I select the following items:
      | Essex                   |
    And I click on 'Continue'
    Then I am on the 'Annual contract cost' page
    And I enter '123456' for the annual contract cost
    And I click on 'Continue'
    Then I am on the 'Results' page

  Scenario Outline: Contract name is blank
    Given I click on '<save_button>'
    Then I should see the following error messages:
      | Enter your contract name  |

  Examples:
      | save_button                               |
      | Save and continue                         |
      # | Save and return to procurements dashboard |

  Scenario: Contract name is taken
    Given I have a procurement with the name 'Taken contract name'
    And I enter 'Taken contract name' into the contract name field
    And I click on 'Save and continue'
    Then I should see the following error messages:
      | This contract name is already in use  |

  # Some steps are commented out due to us not showing the state on the dahsboard anymore
