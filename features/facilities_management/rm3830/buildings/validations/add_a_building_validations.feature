Feature: Add a building - validations

  Background: Navigate to buildings page
    Given I sign in and navigate to my account for 'RM3830'
    And I have buildings
    And I click on 'Manage my buildings'
    Then I am on the 'Buildings' page
    And I click on 'Add a building'
    Then I am on the 'Add a building' page

  Scenario Outline: Add a building - empty fields
    And I click on '<save_button>'
    Then I should see the following error messages:
      | Enter a name for your building        |
      | Enter a valid postcode, like AA1 1AA  |

    Examples:
      | save_button                                   |
      | Save and continue                             |
      | Save and return to building details summary   |

  Scenario: Add a building - building name taken
    And I enter 'Test building' for the building name
    And I click on 'Save and continue'
    Then I should see the following error messages:
      | This building name is already in use  |
      | Enter a valid postcode, like AA1 1AA  |

  @javascript
  Scenario Outline: Add a building - postcode javascript
    And I enter 'Test building' for the building name
    And I enter the following details into the form:
      | Postcode  | <postcode>  |
    And I click on 'Find address'
    Then I should see the postcode error message
  
    Examples:
        | postcode  |
        |           |
        | test      |

  Scenario: Add a building - postcode backend
    And I enter 'New building' for the building name
    And I enter the following details into the form:
      | Postcode  | test  |
    And I click on 'Save and continue'
    Then I should see the following error messages:
      | Enter a valid postcode, like AA1 1AA  |

  Scenario: Add a building - select address
    And I enter 'New building' for the building name
    And I enter the following details into the form:
      | Postcode  | ST16 1AA  |
    And I click on 'Save and continue'
    Then I should see the following error messages:
      | You must select an address to save a building |

  @javascript
  Scenario: Add a building - select region
    And I enter 'New building' for the building name
    And I enter the following details into the form:
      | Postcode  | LU6 1GQ  |
    And I click on 'Find address'
    And I select '10 Sidings Way, Dunstable' from the address drop down
    And I click on 'Save and continue'
    Then I should see the following error messages:
      | You must select a region for your address |

  Scenario: Add building address - empty fields
    And I enter the following details into the form:
      | Postcode  | ST16 1AA  |
    And I click on 'Find address'
    And I click on 'I can’t find my building’s address in the list'
    Then I am on the 'Add building address' page
    And I click on 'Save and continue'
    Then I should see the following error messages:
      | Add a building and street name  |
      | Enter the town or city          |
