Feature: Notices contact detail

  Background: Navigate to the Notices contact detail question
    Given I sign in and navigate to my account for 'RM3830'
    And I have a procurement in DA draft at the 'contract_details' stage named 'Contact detail procurement'
    When I navigate to the procurement 'Contact detail procurement'
    Then I am on the 'Contract details' page
    And I answer the 'Notices contact details' contract detail question
    Then I am on the 'Notices contact details' page

  Scenario: When buyer details are selected
    Given I select the buyer details for the contact details
    And I click on 'Continue'
    Then I am on the 'Contract details' page
    And my 'Notices contact details' contact detail name matchs the buyer details
    Then I open the details for the 'Notices contact details'
    And my 'Notices contact details' contact details match the buyer details

  @javascript
  Scenario: Entering new details is selected
    Given I select 'Enter a new contact for notices' for the contact details
    And I click on the button with text 'Continue'
    Then I am on the 'New notices contact details' page
    And I enter 'Testim' for the notices contact detail 'Name'
    And I enter 'Tester' for the notices contact detail 'Job title'
    And I enter 'tes@test.com' for the notices contact detail 'Email'
    And I enter 'ST16 1AA' for the notices contact detail 'Postcode'
    And I click on 'Find address'
    And I select 'Stafford Delivery Office, Newport Road, Stafford' from the address drop down
    And I click on 'Save and return'
    Then I am on the 'Notices contact details' page
    And I should see 'Testim, Tester' for the contact detail name
    And I should see 'Stafford Delivery Office, Newport Road, Stafford ST16 1AA' for the contact detail address
    And I click on 'Continue'
    Then I am on the 'Contract details' page
    And my 'Notices contact details' contact detail name is 'Testim, Tester'
    Then I open the details for the 'Notices contact details'
    And my 'Notices contact details' contact details are as follows:
      | tes@test.com                                                |
      | Stafford Delivery Office, Newport Road, Stafford ST16 1AA  |

  @javascript
  Scenario: Entering new details is selected - changing the details
    Given I select 'Enter a new contact for notices' for the contact details
    And I click on the button with text 'Continue'
    Then I am on the 'New notices contact details' page
    And I enter 'Testim' for the notices contact detail 'Name'
    And I enter 'Tester' for the notices contact detail 'Job title'
    And I enter 'tes@test.com' for the notices contact detail 'Email'
    And I enter 'ST16 1AA' for the notices contact detail 'Postcode'
    And I click on 'Find address'
    And I select 'Stafford Delivery Office, Newport Road, Stafford' from the address drop down
    And I click on 'Save and return'
    Then I am on the 'Notices contact details' page
    And I should see 'Testim, Tester' for the contact detail name
    And I should see 'Stafford Delivery Office, Newport Road, Stafford ST16 1AA' for the contact detail address
    Given I click on 'Change'
    Then I am on the 'New notices contact details' page
    And I enter 'Testom' for the notices contact detail 'Name'
    And I change my contact detail address
    And I enter 'AA1 1AA' for the notices contact detail 'Postcode'
    And I click on 'Find address'
    And I change my contact detail postcode
    And I enter 'ST19 5AF' for the notices contact detail 'Postcode'
    And I click on 'Find address'
    And I select 'Littleton Mews, Clay Street, Penkridge' from the address drop down
    And I click on 'Save and return'
    Then I am on the 'Notices contact details' page
    And I should see 'Testom, Tester' for the contact detail name
    And I should see 'Littleton Mews, Clay Street, Penkridge ST19 5AF' for the contact detail address
    And I click on 'Continue'
    Then I am on the 'Contract details' page
    And my 'Notices contact details' contact detail name is 'Testom, Tester'
    Then I open the details for the 'Notices contact details'
    And my 'Notices contact details' contact details are as follows:
      | tes@test.com                                    |
      | Littleton Mews, Clay Street, Penkridge ST19 5AF |

  @javascript
  Scenario: Entering new details is selected - add address manually
    Given I select 'Enter a new contact for notices' for the contact details
    And I click on the button with text 'Continue'
    Then I am on the 'New notices contact details' page
    And I enter 'Nial Ladair' for the notices contact detail 'Name'
    And I enter 'Emperor' for the notices contact detail 'Job title'
    And I enter 'XC2 0MA' for the notices contact detail 'Postcode'
    And I click on 'Find address'
    And I click on the link with text 'Enter address manually, if you can’t find address'
    Then I am on the 'Add address' page
    And I enter 'Hardhaigh Palace' for the notices contact detail 'Building and street'
    And I enter 'Alba Cavanich' for the notices contact detail 'Building and street address line 2'
    And I enter 'Mor Ardain' for the notices contact detail 'Town or city'
    And I enter 'Alrest' for the notices contact detail 'County'
    And I enter 'SI4 5GX' for the notices contact detail 'Postcode'
    And I click on 'Continue'
    Then I am on the 'New notices contact details' page
    And I enter 'emperor@hardhaigh.palac.gov.ma' for the notices contact detail 'Email'
    And I click on 'Save and return'
    Then I am on the 'Notices contact details' page
    And I should see 'Nial Ladair, Emperor' for the contact detail name
    And I should see 'Hardhaigh Palace, Alba Cavanich, Mor Ardain, Alrest SI4 5GX' for the contact detail address
    And I click on 'Continue'
    Then I am on the 'Contract details' page
    And my 'Notices contact details' contact detail name is 'Nial Ladair, Emperor'
    Then I open the details for the 'Notices contact details'
    And my 'Notices contact details' contact details are as follows:
      | emperor@hardhaigh.palac.gov.ma                              |
      | Hardhaigh Palace, Alba Cavanich, Mor Ardain, Alrest SI4 5GX |
    
  Scenario: Return links work and options are reset
    Given I select 'Enter a new contact for notices' for the contact details
    And I click on 'Continue'
    Then I am on the 'New notices contact details' page
    Then I click on 'Enter address manually, if you can’t find address'
    Then I am on the 'Add address' page
    When I click on the 'Return to new notices contact details' back link
    Then I am on the 'New notices contact details' page
    When I click on the 'Return to notices contact details' back link
    Then I am on the 'Notices contact details' page
    When I click on the 'Return to contract details' back link
    Then I am on the 'Contract details' page
    And my answer to the 'Notices contact details' contract detail question is 'Answer question'
    Given I answer the 'Notices contact details' contract detail question
    Then I am on the 'Notices contact details' page
    And I select 'Enter a new contact for notices' for the contact details
    And I click on 'Continue'
    Then I am on the 'New notices contact details' page
    Then I click on 'Enter address manually, if you can’t find address'
    Then I am on the 'Add address' page
    When I click on the 'Return to new notices contact details' return link
    Then I am on the 'New notices contact details' page
    When I click on the 'Return to notices contact details' return link
    Then I am on the 'Notices contact details' page
    When I click on the 'Return to contract details' return link
    Then I am on the 'Contract details' page
    And my answer to the 'Notices contact details' contract detail question is 'Answer question'
