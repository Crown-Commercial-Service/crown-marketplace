@javascript
Feature: Buyer details

  Background: Navigate to Buyer Details page
    Given I sign in without details for 'RM3830'
    And I enter the following details into the form:
      | Name              | Testy McTestface  |
      | Job title         | Tester            |
      | Telephone number  | 01610161016       |
      | Organisation name | Feel Good inc.    |
      | Postcode          | ST16 1AA          |
    And I check 'Central government' for the sector

  Scenario: Save details for the buyer - add address normally
    And I click on 'Find address'
    And I select 'Stafford Delivery Office, Newport Road, Stafford' from the address drop down
    And I click on 'Save and continue'
    And I am on the Your account page
    And I click on 'Manage my details'
    Then I am on the 'Manage your details' page
    And the following buyer details have been entered:
      | Name                  | Testy McTestface                                          |
      | Job title             | Tester                                                    |
      | Telephone number      | 01610161016                                               |
      | Organisation name     | Feel Good inc.                                            |
      | Organisation address  | Stafford Delivery Office, Newport Road, Stafford ST16 1AA |
      | Sector                | Central government                                        |

  Scenario: Save details for the buyer - add address manually
    And I click on 'Find address'
    And I click on 'Enter address manually, if you can’t find address'
    Then I am on the 'Add address' page
    And I enter the following details into the form:
      | Building and street | 112 Test street |
      | Town or city        | Westminister    |
      | Postcode            | AA1 1AA         |
    And I click on 'Save and continue'
    Then I am on the 'Manage your details' page
    And I click on 'Save and continue'
    And I am on the Your account page
    And I click on 'Manage my details'
    Then I am on the 'Manage your details' page
    And the following buyer details have been entered:
      | Name                  | Testy McTestface                      |
      | Job title             | Tester                                |
      | Telephone number      | 01610161016                           |
      | Organisation name     | Feel Good inc.                        |
      | Organisation address  | 112 Test street, Westminister AA1 1AA |
      | Sector                | Central government                    |
