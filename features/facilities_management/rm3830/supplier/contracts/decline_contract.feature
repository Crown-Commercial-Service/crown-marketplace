@contract_emails
Feature: Supplier accepts contract

  Scenario: Decline the contract
    Given I log in as a supplier with a contract in 'sent' named 'Declined contract'
    And I click on 'Declined contract'
    Then I am on the 'Contract summary' page
    Then I click on 'Respond to this offer'
    And I am on the 'Respond to the contract offer' page
    And I respond to this contract offer with 'No'
    And I enter the reason for declining the contract:
      | Sorry, I can't belive you've done this  |
      | What a ridiculous offer                 |
    When I click on 'Confirm and continue'
    Then I am on the 'You have declined this contract offer' page
    And I click on 'Return to dashboard'
    And I am on the 'Direct award dashboard' page
    Then I should see the following contracts on the dashboard in the section:
      | Closed  | Declined contract |
    Then I click on 'Declined contract'
    Then I am on the 'Contract summary' page
    Then there is a warning with the text 'Declined'
    And the key details include:
      | You declined this contract offer  |
    And my reason for not declining is:
      | Sorry, I can't belive you've done this  |
      | What a ridiculous offer                 |
    And I should see the following text within the contract offer history:
      | This contract offer was received on   |
    Then I click on the 'Return to dashboard' return link
    And I am on the 'Direct award dashboard' page
    When I click on 'Declined contract'
    And I am on the 'Contract summary' page
    Then I click on the 'Return to dashboard' back link
    And I am on the 'Direct award dashboard' page
