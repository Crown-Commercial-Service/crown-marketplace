Feature: Supplier signed contract

  Scenario: Signed contract
    Given I log in as a supplier with a contract in 'signed' named 'Signed contract'
    Then I should see the following contracts on the dashboard in the section:
      | Contracts | Signed contract |
    And I click on 'Signed contract'
    Then I am on the 'Contract summary' page
    Then there is a warning with the text 'Accepted and signed'
    And the key details include:
      | The buyer confirmed that the contract period is between |
    And I should see the following text within the contract offer history:
      | You accepted this contract offer  |
      | This contract offer was received  |
    Then I click on the 'Return to dashboard' return link
    And I am on the 'Direct award dashboard' page
    And I click on 'Signed contract'
    Then I click on the 'Return to dashboard' back link
    And I am on the 'Direct award dashboard' page