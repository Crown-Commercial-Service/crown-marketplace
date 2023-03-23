Feature: Supplier expired contract

  Scenario: Expired contract
    Given I log in as a supplier with a contract in 'expired' named 'Expired contract'
    Then I should see the following contracts on the dashboard in the section:
      | Closed  | Expired contract |
    And I click on 'Expired contract'
    Then I am on the 'Contract summary' page
    Then there is a warning with the text 'Not responded'
    And the key details include:
      | You did not respond to this contract offer within the required timescales, therefore it was automatically declined with the reason of 'no response'.  |
    And I should see the following text within the contract offer history:
      | This contract offer was closed    |
      | This contract offer was received  |
    Then I click on the 'Return to dashboard' return link
    And I am on the 'Direct award dashboard' page
    And I click on 'Expired contract'
    Then I click on the 'Return to dashboard' back link
    And I am on the 'Direct award dashboard' page