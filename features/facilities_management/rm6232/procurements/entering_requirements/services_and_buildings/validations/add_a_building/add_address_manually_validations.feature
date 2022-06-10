Feature: Add address manually in requirements - validations

  Background:
    Given I sign in and navigate to my account for 'RM6232'
    And I have buildings
    And I have an empty procurement for entering requirements named 'My buildings procurement'
    When I navigate to the procurement 'My buildings procurement'
    Then I am on the 'Further service and contract requirements' page
    And I click on 'Buildings'
    Then I am on the 'Buildings' page
    And I click on 'Add a building'
    Then I am on the 'Add a building' page
    And I enter 'New building' for the building name
    And I enter the following details into the form:
      | Postcode  | ST16 1AA  |
    And I click on 'Find address'
    And I click on 'I can’t find my building’s address in the list'
    Then I am on the 'Add building address' page

  Scenario: Add Address manually - nothing entered
    And I click on 'Save and continue'
    Then I should see the following error messages:
      | Add a building and street name        |
      | Enter the town or city                |

  Scenario Outline: Add Address manually - postcode validation
    And I enter the following details into the form:
      | Building and street line 1 of 2 | 112 Test street |
      | Town or city                    | Westminister    |
      | Postcode                        | <postocde>      |
    And I click on 'Save and continue'
    Then I should see the following error messages:
      | Enter a valid postcode, like AA1 1AA |

    Examples:
        | postocde  |
        |           |
        | toast     |
    