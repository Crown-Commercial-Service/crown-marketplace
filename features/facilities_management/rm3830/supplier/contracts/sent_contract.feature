Feature: Supplier sent contract

  Scenario: Sent contract
    Given I log in as a supplier with a contract in 'sent' named 'Sent contract'
    And I click on 'Sent contract'
    Then I am on the 'Contract summary' page
    Then there is a warning with the text 'Received contract offer'
    And the key details include:
      | This contract offer expires                                                       |
      | The buyer is waiting for a response before the offer expiry deadline shown above. |
    And I should see the following text within the contract offer history:
      | This contract offer was received on   |
    And the what happens next 'details' titles are:
      | 1. Review the offer       |
      | 2. Accepting an offer     |
      | 3. Declining an offer     |
      | 4. Not responding in time |
    And the contract summary footer has the following text:
      | Please click on the button below to either accept or decline. |
    Then I click on the 'Return to dashboard' return link
    And I am on the 'Direct award dashboard' page
    And I click on 'Sent contract'
    Then I click on the 'Return to dashboard' back link
    And I am on the 'Direct award dashboard' page
