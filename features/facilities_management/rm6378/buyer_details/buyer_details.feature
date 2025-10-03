@javascript
Feature: Buyer details

  Background: Navigate to Buyer Details page
    Given I sign in without details for 'RM6378'
    And I click on 'Answer questions (Personal details)'
    Then I am on the 'Manage your personal details' page
    And I enter the following details into the form:
      | Name             | Testy McTestface |
      | Job title        | Tester           |
      | Telephone number | 01610161016      |
    And I click on 'Save and return'
    Then I am on the 'Your details' page
    And I click on 'Answer question (Contact preferences)'
    Then I am on the 'Manage your contact preferences' page
    And I check 'No' for being contacted
    And I click on 'Save and return'
    Then I am on the 'Your details' page
    And I click on 'Answer questions (Organisation details)'
    And I enter the following details into the form:
      | Organisation name | Feel Good inc. |
      | Postcode          | ST16 1AA       |
    And I check 'Local Community and Housing' for the sector

  Scenario: Save details for the buyer - add address normally
    And I click on 'Find address'
    And I select 'The Goods Shed, Newport Road, Stafford' from the address drop down
    And I click on 'Save and return'
    And I am on the 'Your details' page
    And the following buyer details have been entered for 'Personal details':
      | Name             | Testy McTestface |
      | Job title        | Tester           |
      | Telephone number | 01610161016      |
    And the following buyer details have been entered for 'Organisation details':
      | Organisation name                  | Feel Good inc.                                  |
      | Organisation address               | The Goods Shed, Newport Road, Stafford ST16 1AA |
      | Type of public sector organisation | Local Community and Housing                     |
    And the following buyer details have been entered for 'Contact preferences':
      | CCS can contact you about searches? | No |

  Scenario: Save details for the buyer - add address manually
    And I click on 'Find address'
    And I click on 'Enter address manually'
    And I enter the following details into the form:
      | Address line 1 | 112 Test street |
      | Town or city   | Westminister    |
      | Postcode       | AA1 1AA         |
    And I click on 'Save and return'
    And I am on the 'Your details' page
    And the following buyer details have been entered for 'Personal details':
      | Name             | Testy McTestface |
      | Job title        | Tester           |
      | Telephone number | 01610161016      |
    And the following buyer details have been entered for 'Organisation details':
      | Organisation name                  | Feel Good inc.                        |
      | Organisation address               | 112 Test street, Westminister AA1 1AA |
      | Type of public sector organisation | Local Community and Housing           |
    And the following buyer details have been entered for 'Contact preferences':
      | CCS can contact you about searches? | No |
