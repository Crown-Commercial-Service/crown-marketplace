Feature: Supplier contact information - validations

  Background: Navigate to the additional supplier information section
    Given I sign in as an admin and navigate to the 'RM3830' dashboard
    And I click on 'Supplier details'
    Then I am on the 'Supplier details' page
    And I click on 'Kemmer Group'
    Then I am on the 'Supplier details' page
    And I change the 'DUNS number' for the supplier details
    Then I am on the 'Additional supplier information' page

  Scenario Outline: DUNS number validation
    Given I enter '<duns_number>' into the 'DUNS number' field
    And I click on 'Save and return'
    Then I should see the following error messages:
      | <error_message> |

    Examples:
      | duns_number | error_message                                                                     |
      |             | Enter the DUNS number                                                             |
      | fakeduns    | Enter the DUNS number in the correct format with 9 digits, for example 214567885  |
      | 12345678    | Enter the DUNS number in the correct format with 9 digits, for example 214567885  |

  Scenario Outline: Company registration number
    Given I enter '<crn>' into the 'Company registration number' field
    And I click on 'Save and return'
    Then I should see the following error messages:
      | <error_message> |
    
    Examples:
      | crn       | error_message                                                                     |
      |           | Enter the company registration number                                             |
      | fafecrn   | Enter the company registration number in the correct format, for example AC123456 |
      | A1234567  | Enter the company registration number in the correct format, for example AC123456 |
      | ABC12345  | Enter the company registration number in the correct format, for example AC123456 |
      | ac123456  | Enter the company registration number in the correct format, for example AC123456 |