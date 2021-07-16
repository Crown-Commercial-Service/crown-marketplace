@accessibility @javascript
Feature: Contract options accessibility

  Background: I navigate to my sent contract
    Given I sign in and navigate to my account
    And I have a contract that has been 'accepted' called 'My contract'
    And I click on 'Continue a procurement'
    Then I navigate to the contract 'My contract' in 'Sent offers'

  Scenario: Confirm if signed
    Then I click on 'Confirm if contract signed or not'
    And I am on the 'Confirmation of signed contract' page
    Then the page should be axe clean

  Scenario: Close contract
    Then I click on 'Close this procurement'
    And I am on the 'Are you sure you wish to close' page
    Then the page should be axe clean

  Scenario: Contract signed page
    Then I click on 'Confirm if contract signed or not'
    And I am on the 'Confirmation of signed contract' page
    And I select 'Yes' for the confirmation of signed contract
    And I enter a contract start date 2 years and 0 months into the future
    And I enter a contract end date 5 years and 0 months into the future
    And I click on 'Save and continue'
    Then I am on the 'Contract signed' page
    Then the page should be axe clean

  Scenario: Contract has been closed
    Then I click on 'Close this procurement'
    And I am on the 'Are you sure you wish to close' page
    And I enter the reason for closing the contract:
      | The procurement is no longer required |
    Then I click on 'Close this procurement'
    Then I am on the 'Your procurement has been closed' page
    Then the page should be axe clean

  Scenario: Send to next supplier page
    Then I click on 'Confirm if contract signed or not'
    And I am on the 'Confirmation of signed contract' page
    And I select 'No' for the confirmation of signed contract
    And I enter the reason for not signing:
      | Some reason |
    Then I click on 'Save and continue'
    And I am on the 'Contract summary' page
    Then I click on "View next supplier's price"
    And I am on the 'Offer to next supplier' page
    Then the page should be axe clean

  Scenario: Contract sent
    Then I click on 'Confirm if contract signed or not'
    And I am on the 'Confirmation of signed contract' page
    And I select 'No' for the confirmation of signed contract
    And I enter the reason for not signing:
      | Some reason |
    Then I click on 'Save and continue'
    And I am on the 'Contract summary' page
    Then I click on "View next supplier's price"
    And I am on the 'Offer to next supplier' page
    And I click on 'Confirm and send offer to supplier'
    Then I am on the 'Your contract was sent' page
    Then the page should be axe clean
