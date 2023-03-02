Feature: Supplier not signed contract

  Scenario: Not signed contract
    Given I log in as a supplier with a contract in 'not_signed' named 'Not signed contract'
    Then I should see the following contracts on the dashboard in the section:
      | Closed  | Not signed contract |
    And I click on 'Not signed contract'
    Then I am on the 'Contract summary' page
    Then there is a warning with the text 'Not signed'
    And the key details include:
      | The buyer has recorded this contract as 'not signed'  |
      | The contract offer has therefore been closed.         |
    And the buyers reason for not signing is:
      | The supplier would not respond to my emails |
    And I should see the following text within the contract offer history:
      | You accepted this contract offer  |
      | This contract offer was received  |
    Then I click on the 'Return to dashboard' return link
    And I am on the 'Direct award dashboard' page
    And I click on 'Not signed contract'
    Then I click on the 'Return to dashboard' back link
    And I am on the 'Direct award dashboard' page