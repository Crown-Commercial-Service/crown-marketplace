Feature: Buyer details - validations

  Background: Navigate to Buyer Details page
    Given I sign in without details for 'RM6378'

  Scenario: Save and return - Personal details - empty field
    And I click on 'Answer questions (Personal details)'
    Then I am on the 'Manage your personal details' page
    When I click on 'Save and return'
    Then I should see the following error messages:
      | Enter your full name                                   |
      | Enter your job title                                   |
      | Enter a UK telephone number, for example 020 7946 0000 |

  Scenario: Save and return - Organisation details - empty field
    And I click on 'Answer questions (Organisation details)'
    Then I am on the 'Manage your organisation details' page
    When I click on 'Save and return'
    Then I should see the following error messages:
      | Enter your organisation name                                    |
      | Enter your building or street name                              |
      | Enter your town or city                                         |
      | Enter a valid postcode, for example SW1A 1AA                    |
      | Select the type of public sector organisation you’re buying for |

  Scenario: Save and return - Contact preferences - empty field
    And I click on 'Answer question (Contact preferences)'
    Then I am on the 'Manage your contact preferences' page
    When I click on 'Save and return'
    Then I should see the following error messages:
      | You must select an option |

  @javascript
  Scenario Outline: Add address - frontend
    And I click on 'Answer questions (Organisation details)'
    Then I am on the 'Manage your organisation details' page
    And I enter the following details into the form:
      | Postcode | <postcode> |
    And I click on 'Find address'
    Then I should see the postcode error message for buyer details

    Examples:
      | postcode |
      |          |
      | test     |

  @javascript
  Scenario: Add address - Bad postcode
    And I click on 'Answer questions (Organisation details)'
    Then I am on the 'Manage your organisation details' page
    And I enter the following details into the form:
      | Organisation name | Feel Good inc. |
      | Postcode          | test           |
    And I check 'Defence and Security' for the sector
    And I click on 'Save and return'
    Then I should see the following error messages:
      | Enter your building or street name           |
      | Enter your town or city                      |
      | Enter a valid postcode, for example SW1A 1AA |
    Then I should see the other address field error messages for buyer details
    Then I should see the postcode error message for buyer details

  @javascript
  Scenario: Add address - Nothing entered
    And I click on 'Answer questions (Organisation details)'
    Then I am on the 'Manage your organisation details' page
    And I enter the following details into the form:
      | Organisation name | Feel Good inc. |
      | Postcode          |                |
    And I check 'Defence and Security' for the sector
    And I click on 'Save and return'
    Then I should see the following error messages:
      | Enter a valid postcode, for example SW1A 1AA |
    Then I should not see the other address errors
    Then I should see the postcode error message for buyer details

  @javascript
  Scenario: Add address - Nothing selected
    And I click on 'Answer questions (Organisation details)'
    Then I am on the 'Manage your organisation details' page
    And I enter the following details into the form:
      | Organisation name | Feel Good inc. |
      | Postcode          | ST16 1AA       |
    And I check 'Defence and Security' for the sector
    And I click on 'Save and return'
    Then I should see the following error messages:
      | Enter your building or street name |
      | Enter your town or city            |
    Then I should see the other address field error messages for buyer details

  @javascript
  Scenario: Add address - Change
    And I click on 'Answer questions (Organisation details)'
    Then I am on the 'Manage your organisation details' page
    And I enter the following details into the form:
      | Organisation name | Feel Good inc. |
      | Postcode          | test           |
    And I check 'Defence and Security' for the sector
    And I click on 'Save and return'
    Then I should see the following error messages:
      | Enter your building or street name           |
      | Enter your town or city                      |
      | Enter a valid postcode, for example SW1A 1AA |
    Then I should see the other address field error messages for buyer details
    Then I should see the postcode error message for buyer details
    And I click on 'Change address'
    Then I should not see the other address errors
    And I should not see the postcode error message for buyer details
