Feature: Supplier address - validations

  Background: Navigate to the supplier address section
    Given I sign in as an admin and navigate to the 'RM3830' dashboard
    And I click on 'Supplier details'
    Then I am on the 'Supplier details' page
    And I click on 'Shields, Ratke and Parisian'
    Then I am on the 'Supplier details' page
    And I change the 'Full address' for the supplier details
    Then I am on the 'Supplier address' page

  Scenario: Full address - nothing entered
    And I enter the following details into the form:
      | Building and street | |
      | Town or city        | |
    And I click on 'Save and return'
    Then I should see the following error messages:
      | Enter the building or street name |
      | Enter the town or city            |

  Scenario Outline: Full address - postcode validation
    And I enter the following details into the form:
      | Building and street | 112 Test street |
      | Town or city        | Westminister    |
      | Postcode            | <postocde>      |
    And I click on 'Save and return'
    Then I should see the following error messages:
      | Enter a valid postcode, for example SW1A 1AA  |

    Examples:
        | postocde  |
        |           |
        | toast     |
        | A1111A    |