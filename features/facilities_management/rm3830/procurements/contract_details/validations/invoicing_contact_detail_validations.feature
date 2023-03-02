Feature: Invoicing contact detail validations

  Background: Navigate to the Invoicing contact detail question
    Given I sign in and navigate to my account for 'RM3830'
    And I have a procurement in DA draft at the 'contract_details' stage named 'Contact detail procurement'
    When I navigate to the procurement 'Contact detail procurement'
    Then I am on the 'Contract details' page
    And I answer the 'Invoicing contact details' contract detail question
    Then I am on the 'Invoicing contact details' page
  
  Scenario: Nothing is selected
    Given I click on 'Continue'
    Then I should see the following error messages:
      | Select one option |

  Scenario: Enter a new detail is selected and everything is blank
    Given I select 'Enter a new invoicing contact' for the contact details
    And I click on 'Continue'
    Then I am on the 'New invoicing contact details' page
    And I click on 'Save and return'
    Then I should see the following error messages:
      | Enter the new invoicing contact name                                                |
      | Enter the new invoicing contact job title                                           |
      | Enter an email address in the correct format, for example name@organisation.gov.uk  |
      | Enter a valid postcode, for example SW1A 1AA                                        |

  Scenario: Email and postcode invalid
    Given I select 'Enter a new invoicing contact' for the contact details
    And I click on 'Continue'
    Then I am on the 'New invoicing contact details' page
    And I enter 'Testim' for the invoicing contact detail 'Name'
    And I enter 'Tester' for the invoicing contact detail 'Job title'
    And I enter 'Tes@tes' for the invoicing contact detail 'Email'
    And I enter 'PLUS ULTRA' for the invoicing contact detail 'Postcode' 
    And I click on 'Save and return'
    Then I should see the following error messages:
      | Enter an email address in the correct format, for example name@organisation.gov.uk  |
      | Enter a valid postcode, for example SW1A 1AA                                        |

  Scenario: Select an address
    Given I select 'Enter a new invoicing contact' for the contact details
    And I click on 'Continue'
    Then I am on the 'New invoicing contact details' page
    And I enter 'Testim' for the invoicing contact detail 'Name'
    And I enter 'Tester' for the invoicing contact detail 'Job title'
    And I enter 'tes@test.com' for the invoicing contact detail 'Email'
    And I enter 'ST16 1AA' for the invoicing contact detail 'Postcode' 
    And I click on 'Save and return'
    Then I should see the following error messages:
      | Select an address from the list or add a missing address  |

  Scenario: Add address manually all blank
    Given I select 'Enter a new invoicing contact' for the contact details
    And I click on 'Continue'
    Then I am on the 'New invoicing contact details' page
    And I click on 'Enter address manually, if you can’t find address'
    Then I am on the 'Add address' page
    And I click on 'Continue'
    Then I should see the following error messages:
      | Enter the building or street name of the address  |
      | Enter the town or city of the address             |
      | Enter a valid postcode, for example SW1A 1AA      |

  Scenario: Add address manually invalid postcode
    Given I select 'Enter a new invoicing contact' for the contact details
    And I click on 'Continue'
    Then I am on the 'New invoicing contact details' page
    And I click on 'Enter address manually, if you can’t find address'
    Then I am on the 'Add address' page
    And I enter 'Some addrees info' for the invoicing contact detail 'Building and street'
    And I enter 'Mor Ardain' for the invoicing contact detail 'Town or city' 
    And I enter 'TURTUS' for the invoicing contact detail 'Postcode' 
    And I click on 'Continue'
    Then I should see the following error messages:
      | Enter a valid postcode, for example SW1A 1AA      |
