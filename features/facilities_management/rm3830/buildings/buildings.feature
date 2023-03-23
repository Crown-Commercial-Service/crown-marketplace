@javascript
Feature: Buildings

  Background:
    Given I sign in and navigate to my account for 'RM3830'
    And I click on 'Manage my buildings'
    Then I am on the 'Buildings' page

  @add_address
  Scenario: Add a Building - no region selection
    And I click on 'Add a building'
    Then I am on the 'Add a building' page
    And I enter 'New building' for the building name
    And I enter the following details into the form:
      | Postcode  | ST16 1AA  |
    And I click on 'Find address'
    And I select 'Stafford Delivery Office, Newport Road, Stafford' from the address drop down
    Then the address 'Stafford Delivery Office, Newport Road, Stafford ST16 1AA' is displayed
    And the region 'Shropshire and Staffordshire' is displayed
    And I can't change the region
    Then I click on 'Save and continue'
    Then I am on the 'Internal and external areas' page

  Scenario: Add a Building - region selection
    And I click on 'Add a building'
    Then I am on the 'Add a building' page
    And I enter 'New building' for the building name
    And I enter the following details into the form:
      | Postcode  | LU6 1GQ  |
    And I click on 'Find address'
    And I select '10 Sidings Way, Dunstable' from the address drop down
    And I select 'Bedfordshire and Hertfordshire' from the region drop down
    Then the address '10 Sidings Way, Dunstable LU6 1GQ' is displayed
    And the region 'Bedfordshire and Hertfordshire' is displayed
    And I can change the region
    And I click on 'Save and continue'
    Then I am on the 'Internal and external areas' page

  @add_address
  Scenario: Add Address manually - no region selection
    And I click on 'Add a building'
    Then I am on the 'Add a building' page
    And I enter 'New building' for the building name
    And I enter the following details into the form:
      | Postcode  | ST16 1AA  |
    And I click on 'Find address'
    And I click on 'I can’t find my building’s address in the list'
    And I enter the following details into the form:
      | Building and street line 1 of 2             | 112 Test street |
      | Building and street line 2 of 2 (optional)  | Zone 7          |
      | Town or city                                | Westminister    |
      | Postcode                                    | ST16 1AA        |
    And I click on 'Save and continue'
    Then I am on the 'Add a building' page
    Then the address '112 Test street, Zone 7, Westminister ST16 1AA' is displayed
    And the region 'Shropshire and Staffordshire' is displayed  
    And I can't change the region
    Then I click on 'Save and continue'
    Then I am on the 'Internal and external areas' page

  Scenario: Add Address manually - no region selection
    And I click on 'Add a building'
    Then I am on the 'Add a building' page
    And I enter 'New building' for the building name
    And I enter the following details into the form:
      | Postcode  | ST16 1AA  |
    And I click on 'Find address'
    And I click on 'I can’t find my building’s address in the list'
    Then I am on the 'Add building address' page
    And the framework is 'RM3830'
    And I enter the following details into the form:
      | Building and street line 1 of 2 | 1 Windsor Avenue  |
      | Town or city                    | Aberdeen          |
      | Postcode                        | NW1 4DF           |
    And I click on 'Save and continue'
    Then I am on the 'Add a building' page
    Then the address '1 Windsor Avenue, Aberdeen NW1 4DF' is displayed
    And I select 'Aberdeen and Aberdeenshire' from the region drop down
    And the region 'Aberdeen and Aberdeenshire' is displayed  
    And I can change the region
    Then I click on 'Save and continue'
    Then I am on the 'Internal and external areas' page

  @add_address
  Scenario: Internal and External Area - external area 0
    And I click on 'Add a building'
    Then I am on the 'Add a building' page
    And I enter 'New building' for the building name
    And I enter the following details into the form:
      | Postcode  | ST16 1AA  |
    And I click on 'Find address'
    And I select 'Stafford Delivery Office, Newport Road, Stafford' from the address drop down
    Then I click on 'Save and continue'
    Then I am on the 'Internal and external areas' page
    And I enter '300' for the building 'GIA'
    And I enter '0' for the building 'external area'
    And I click on 'Save and continue'
    Then I am on the 'Building type' page

  @add_address
  Scenario: Internal and External Area - internal area 0
    And I click on 'Add a building'
    Then I am on the 'Add a building' page
    And I enter 'New building' for the building name
    And I enter the following details into the form:
      | Postcode  | ST16 1AA  |
    And I click on 'Find address'
    And I select 'Stafford Delivery Office, Newport Road, Stafford' from the address drop down
    Then I click on 'Save and continue'
    Then I am on the 'Internal and external areas' page
    And I enter '0' for the building 'GIA'
    And I enter '300' for the building 'external area'
    And I click on 'Save and continue'
    Then I am on the 'Building type' page

  @add_address
  Scenario: Add a building complete journey
    And I click on 'Add a building'
    Then I am on the 'Add a building' page
    And the framework is 'RM3830'
    And I enter 'New building' for the building name
    And I enter the following details into the form:
      | Postcode  | ST16 1AA  |
    And I click on 'Find address'
    And I select 'Stafford Delivery Office, Newport Road, Stafford' from the address drop down
    Then I click on 'Save and continue'
    Then I am on the 'Internal and external areas' page
    And the framework is 'RM3830'
    And I enter '300' for the building 'GIA'
    And I enter '600' for the building 'external area'
    And I click on 'Save and continue'
    Then I am on the 'Building type' page
    And the framework is 'RM3830'
    And I select 'General office - customer facing' for the building type
    And I click on 'Save and continue'
    Then I am on the 'Security clearance' page
    And the framework is 'RM3830'
    And I select 'Baseline personnel security standard (BPSS)' for the security type
    And I click on 'Save and return to building details summary'
    Then I am on the buildings summary page for 'New building'
    And the framework is 'RM3830'
    And my building's 'Name' is 'New building'
    And my building's 'Address' is 'Stafford Delivery Office, Newport Road, Stafford'
    And my building's 'Region' is 'Shropshire and Staffordshire'
    And my building's 'Gross internal area' is '300'
    And my building's 'External area' is '600'
    And my building's 'Building type' is 'General office - customer facing'
    And my building's 'Security clearance' is 'Baseline personnel security standard (BPSS)'
    And my building's status is 'COMPLETED'

  @add_address
  Scenario: Add a building 1 detail at a time and check completion
    And I click on 'Add a building'
    Then I am on the 'Add a building' page
    And I enter 'Test building' for the building 'name'
    And I enter 'My new building' for the building 'description'
    And I enter the following details into the form:
      | Postcode  | ST16 1AA  |
    And I click on 'Find address'
    And I select 'Stafford Delivery Office, Newport Road, Stafford' from the address drop down
    Then I click on 'Save and return to building details summary'
    Then I am on the buildings summary page for 'Test building'  
    And my building's 'Name' is 'Test building'
    And my building's 'Description' is 'My new building'
    And my building's 'Address' is 'Stafford Delivery Office, Newport Road, Stafford'
    And my building's status is 'INCOMPLETE'
    And I change the 'Gross internal area'
    Then I am on the 'Internal and external areas' page
    And I enter '123' for the building 'GIA'
    And I enter '456' for the building 'external area'
    Then I click on 'Save and return to building details summary'
    Then I am on the buildings summary page for 'Test building'  
    And my building's 'Gross internal area' is '123'
    And my building's 'External area' is '456'
    And my building's status is 'INCOMPLETE'
    And I change the 'Building type'
    Then I am on the 'Building type' page
    And I open the 'View more building types' details
    And I select 'Primary school' for the building type
    Then I click on 'Save and return to building details summary'
    Then I am on the buildings summary page for 'Test building'
    And my building's 'Building type' is 'Primary school'
    And my building's status is 'INCOMPLETE'
    And I change the 'Security clearance'
    Then I am on the 'Security clearance' page 
    And I select 'Developed vetting (DV)' for the security type
    And I click on 'Save and return to building details summary'
    Then I am on the buildings summary page for 'Test building'  
    And my building's 'Security clearance' is 'Developed vetting (DV)'
    And my building's status is 'COMPLETED'
