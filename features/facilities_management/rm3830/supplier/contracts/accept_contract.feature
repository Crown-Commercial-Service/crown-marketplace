@contract_emails
Feature: Supplier accepts contract

  Scenario: Accept the contract
    Given I log in as a supplier with a contract in 'sent' named 'Accepted contract'
    And I click on 'Accepted contract'
    Then I am on the 'Contract summary' page
    Then I click on 'Respond to this offer'
    And I am on the 'Respond to the contract offer' page
    And I respond to this contract offer with 'Yes'
    When I click on 'Confirm and continue'
    Then I am on the 'You have accepted this contract offer' page
    And I click on 'Return to dashboard'
    And I am on the 'Direct award dashboard' page
    Then I should see the following contracts on the dashboard in the section:
      | Accepted offers | Accepted contract |
    And I click on 'Accepted contract'
    Then I am on the 'Contract summary' page
    Then there is a warning with the text 'Accepted'
    And the key details include:
      | Awaiting buyer confirmation of signed contract. |
    And I should see the following text within the contract offer history:
      | You accepted this contract offer on   |
      | This contract offer was received on   |
    And the what happens next 'details' titles are:
      | 1. Contract signatures      |
      | 2. Signature confirmation   |
      | 3. Within the contract      |
      | 4. Withdraw before signing  |
    Then I click on the 'Return to dashboard' return link
    And I am on the 'Direct award dashboard' page
    When I click on 'Accepted contract'
    And I am on the 'Contract summary' page
    Then I click on the 'Return to dashboard' back link
    And I am on the 'Direct award dashboard' page