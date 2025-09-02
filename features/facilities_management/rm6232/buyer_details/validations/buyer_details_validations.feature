Feature: Buyer details - validations

  Background: Navigate to Buyer Details page
    Given I sign in without details for 'RM6232'

  Scenario: Save and continue - empty fields
    When I click on 'Save and continue'
    Then I should see the following error messages:
      | Enter your full name                                            |
      | Enter your job title                                            |
      | Enter a UK telephone number, for example 020 7946 0000          |
      | Enter your organisation name                                    |
      | Enter a valid postcode, for example SW1A 1AA                    |
      | Select the type of public sector organisation you’re buying for |
      | You must select an option                                       |

  @javascript
  Scenario Outline: Add address - frontend
    And I enter the following details into the form:
      | Postcode | <postcode> |
    And I click on 'Find address'
    Then I should see the postcode error message for buyer details

    Examples:
      | postcode |
      |          |
      | test     |

  Scenario: Add address - backend
    And I enter the following details into the form:
      | Name              | Testy McTestface |
      | Job title         | Tester           |
      | Telephone number  | 01610161016      |
      | Organisation name | Feel Good inc.   |
      | Postcode          | test             |
    And I check 'Defence and Security' for the sector
    And I check 'Yes' for being contacted
    And I click on 'Save and continue'
    Then I should see the following error messages:
      | Enter a valid postcode, for example SW1A 1AA |

  Scenario: Select address
    And I enter the following details into the form:
      | Name              | Testy McTestface |
      | Job title         | Tester           |
      | Telephone number  | 01610161016      |
      | Organisation name | Feel Good inc.   |
      | Postcode          | ST16 1AA         |
    And I check 'Defence and Security' for the sector
    And I check 'Yes' for being contacted
    And I click on 'Save and continue'
    Then I should see the following error messages:
      | You must select an address to save your details |

  Scenario: Add Address manually - nothing entered
    And I enter the following details into the form:
      | Postcode | ST16 1AA |
    And I click on 'Find address'
    And I click on 'Enter address manually, if you can’t find address'
    Then I am on the 'Add address' page
    And I click on 'Save and continue'
    Then I should see the following error messages:
      | Enter your building or street name           |
      | Enter your town or city                      |
      | Enter a valid postcode, for example SW1A 1AA |

  Scenario Outline: Add Address manually - postcode validation
    And I enter the following details into the form:
      | Postcode | ST16 1AA |
    And I click on 'Find address'
    And I click on 'Enter address manually, if you can’t find address'
    Then I am on the 'Add address' page
    And I enter the following details into the form:
      | Building and street | 112 Test street |
      | Town or city        | Westminister    |
      | Postcode            | <postocde>      |
    And I click on 'Save and continue'
    Then I should see the following error messages:
      | Enter a valid postcode, for example SW1A 1AA |

    Examples:
      | postocde |
      |          |
      | toast    |
