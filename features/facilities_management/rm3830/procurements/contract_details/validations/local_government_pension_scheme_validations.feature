Feature: Local government pension scheme validations

  Background: Navigate to the Local government pension scheme question
    Given I sign in and navigate to my account for 'RM3830'
    And I have a procurement in DA draft at the 'contract_details' stage named 'LGPS procurement'
    When I navigate to the procurement 'LGPS procurement'
    Then I am on the 'Contract details' page
    And I answer the 'Local Government Pension Scheme' contract detail question
    Then I am on the 'Local Government Pension Scheme' page

  Scenario: Nothing is selected
    Given I click on 'Save and continue'
    Then I should see the following error messages:
      | Select one answer |

  Scenario: Yes selected and nothing entered
    Given I select 'Yes' for the LGPS question
    And I click on 'Save and continue'
    Then I am on the 'Pension funds' page
    And I click on 'Save and return'
    Then I should see the following error messages:
      | Enter a pension fund name             |
      | Enter a percentage of pensionable pay |

  Scenario Outline: Basic pension fund percentage validations
    Given I select 'Yes' for the LGPS question
    And I click on 'Save and continue'
    Then I am on the 'Pension funds' page
    And I enter the name 'Pension 1' and '<pension_percentage>' percent for pension number 1
    And I click on 'Save and return'
    Then I should see the following error messages:
      | <error_message> |

    Examples:
      | pension_percentage  | error_message                                                                                       |
      | 0                   | Percentage of pensionable pay must be a number between 0.0001 to 100 inclusive, like 99.9999 or 34  |
      | 100.01              | Percentage of pensionable pay must be a number between 0.0001 to 100 inclusive, like 99.9999 or 34  |
      | 34.00005            | Percentage of pensionable pay must be a number between 0.0001 to 100 inclusive, like 99.9999 or 34  |
      | Zeke von Genbu      | Percentage of pensionable pay must be a number between 0.0001 to 100 inclusive, like 99.9999 or 34  |

  @javascript
  Scenario: Pension name duplication - First entry
    Given I select 'Yes' for the LGPS question
    And I click on 'Save and continue'
    Then I am on the 'Pension funds' page
    And I add 1 pension fund
    And I enter the name 'Unique pension name' and '10' percent for pension number 1
    And I enter the name 'Unique pension name' and '11' percent for pension number 2
    And I click on 'Save and return'
    Then I should see the following error messages:
      | Enter a unique pension fund name, duplication is not allowed  |

  @javascript
  Scenario: Pension name duplication - Saved entry
    Given I select 'Yes' for the LGPS question
    And I click on 'Save and continue'
    Then I am on the 'Pension funds' page
    And I enter the name 'Unique pension name' and '10' percent for pension number 1
    And I click on 'Save and return'
    Then I am on the 'Contract details' page
    And I open the 'Pension scheme details' details
    And I click on 'Add or remove pension funds'
    Then I am on the 'Pension funds' page
    And I add 1 pension fund
    And I enter the name 'Unique pension name' and '11' percent for pension number 2
    And I click on 'Save and return'
    Then I should see the following error messages:
      | Enter a unique pension fund name, duplication is not allowed  |

  @javascript
  Scenario: Multipl pensions multiple errors
    Given I select 'Yes' for the LGPS question
    And I click on 'Save and continue'
    Then I am on the 'Pension funds' page
    And I add 3 pension funds
    And I enter the name 'Pension 1' and '10' percent for pension number 1
    And I enter the name 'Pension 2' and '111' percent for pension number 2
    And I enter the name 'Pension 3' and '' percent for pension number 3
    And I enter the name 'Pension 1' and '0' percent for pension number 4
    And I click on 'Save and return'
    Then I should see the following error messages:
      | Percentage of pensionable pay must be a number between 0.0001 to 100 inclusive, like 99.9999 or 34  |
      | Enter a percentage of pensionable pay                                                               |
      | Percentage of pensionable pay must be a number between 0.0001 to 100 inclusive, like 99.9999 or 34  |
      | Enter a unique pension fund name, duplication is not allowed                                        |
    And pension 2 should have the following error messages:
      | Percentage of pensionable pay must be a number between 0.0001 to 100 inclusive, like 99.9999 or 34  |
    And pension 3 should have the following error messages:
      | Enter a percentage of pensionable pay |
    And pension 4 should have the following error messages:
      | Enter a unique pension fund name, duplication is not allowed                                        |
      | Percentage of pensionable pay must be a number between 0.0001 to 100 inclusive, like 99.9999 or 34  |