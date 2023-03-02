Feature: Supplier contact information - validations

  Background: Navigate to the supplier contact informatin section
    Given I sign in as an admin and navigate to the 'RM3830' dashboard
    And I click on 'Supplier details'
    Then I am on the 'Supplier details' page
    And I click on 'Bogan-Koch'
    Then I am on the 'Supplier details' page
    And I change the 'Contact name' for the supplier details
    Then I am on the 'Supplier contact information' page

  Scenario: Contact name validation
    Given I enter '' into the 'Contact name' field
    And I click on 'Save and return'
    Then I should see the following error messages:
      | You must enter a name for the contact |

  Scenario Outline: Contact email validation
    Given I enter '<contact_email>' into the 'Contact email' field
    And I click on 'Save and return'
    Then I should see the following error messages:
      | <error_message> |

    Examples:
      | contact_email | error_message                                                                       |
      |               | Enter an email address in the correct format, for example name@organisation.gov.uk  |
      | fakeemail     | Enter an email address in the correct format, for example name@organisation.gov.uk  |

  Scenario Outline: Contact telephone number validation
    Given I enter '<contact_telephone_number>' into the 'Contact telephone number' field
    And I click on 'Save and return'
    Then I should see the following error messages:
      | <error_message> |

    Examples:
      | contact_telephone_number  | error_message                                           |
      |                           | You must enter a telephone number for the contact       |
      | fakenumber                | Enter a UK telephone number, for example 020 7946 0000  |
      | 01702 123 456 789         | Enter a UK telephone number, for example 020 7946 0000  |
