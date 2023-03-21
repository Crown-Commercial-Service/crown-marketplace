Feature: Authorised representative detail validations

  Background: Navigate to the Authorised representative detail question
    Given I sign in and navigate to my account for 'RM3830'
    And I have a procurement in DA draft at the 'contract_details' stage named 'Contact detail procurement'
    When I navigate to the procurement 'Contact detail procurement'
    Then I am on the 'Contract details' page
    And I answer the 'Authorised representative details' contract detail question
    Then I am on the 'Authorised representative details' page
  
  Scenario: Nothing is selected
    Given I click on 'Continue'
    Then I should see the following error messages:
      | Select one option |

  Scenario: Enter a new detail is selected and everything is blank
    Given I select 'Enter a new authorised representative' for the contact details
    And I click on 'Continue'
    Then I am on the 'New authorised representative details' page
    And I click on 'Save and return'
    Then I should see the following error messages:
      | Enter the new authorised representative name                                        |
      | Enter the new authorised representative job title                                   |
      | Enter an email address in the correct format, for example name@organisation.gov.uk  |
      | Enter a valid postcode, for example SW1A 1AA                                        |
      | Enter a UK telephone number, for example 020 7946 0000                              |

  Scenario: Email, telephone number and postcode invalid
    Given I select 'Enter a new authorised representative' for the contact details
    And I click on 'Continue'
    Then I am on the 'New authorised representative details' page
    And I enter 'Testim' for the authorised representative detail 'Name'
    And I enter 'Tester' for the authorised representative detail 'Job title'
    And I enter 'Tes@tes' for the authorised representative detail 'Email'
    And I enter '989 123' for the authorised representative detail 'Telephone number'
    And I enter 'PLUS ULTRA' for the authorised representative detail 'Postcode' 
    And I click on 'Save and return'
    Then I should see the following error messages:
      | Enter an email address in the correct format, for example name@organisation.gov.uk  |
      | Enter a valid postcode, for example SW1A 1AA                                        |
      | Enter a UK telephone number, for example 020 7946 0000                              |

  Scenario: Select an address
    Given I select 'Enter a new authorised representative' for the contact details
    And I click on 'Continue'
    Then I am on the 'New authorised representative details' page
    And I enter 'Testim' for the authorised representative detail 'Name'
    And I enter 'Tester' for the authorised representative detail 'Job title'
    And I enter 'tes@test.com' for the authorised representative detail 'Email'
    And I enter '07105 016 101' for the authorised representative detail 'Telephone number'
    And I enter 'ST16 1AA' for the authorised representative detail 'Postcode' 
    And I click on 'Save and return'
    Then I should see the following error messages:
      | Select an address from the list or add a missing address  |

  Scenario: Add address manually all blank
    Given I select 'Enter a new authorised representative' for the contact details
    And I click on 'Continue'
    Then I am on the 'New authorised representative details' page
    And I click on 'Enter address manually, if you can’t find address'
    Then I am on the 'Add address' page
    And I click on 'Continue'
    Then I should see the following error messages:
      | Enter the building or street name of the address  |
      | Enter the town or city of the address             |
      | Enter a valid postcode, for example SW1A 1AA      |

  Scenario: Add address manually invalid postcode
    Given I select 'Enter a new authorised representative' for the contact details
    And I click on 'Continue'
    Then I am on the 'New authorised representative details' page
    And I click on 'Enter address manually, if you can’t find address'
    Then I am on the 'Add address' page
    And I enter 'Some addrees info' for the authorised representative detail 'Building and street'
    And I enter 'Argentum' for the authorised representative detail 'Town or city' 
    And I enter 'Nopon' for the authorised representative detail 'Postcode' 
    And I click on 'Continue'
    Then I should see the following error messages:
      | Enter a valid postcode, for example SW1A 1AA      |
