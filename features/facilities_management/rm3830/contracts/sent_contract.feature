Feature: Sent contract

  Background: I navigate to my sent contract
    Given I sign in and navigate to my account for 'RM3830'
    And I have a contract that has been 'sent' called 'Sent contract'
    And I click on 'Continue a procurement'
    Then I navigate to the contract 'Sent contract' in 'Sent offers'

  Scenario: Sent contract
    Then there is a warning with the text 'Sent'
    And the key details include:
      | This contract offer expires         |
      | The supplier has not yet responded. |
    And I should see the following text within the contract offer history:
      | You sent this contract offer to the supplier  |
    And the what happens next 'list' titles are:
      | If the supplier accepts the offer   |
      | If the supplier declines the offer  |
    And the contract summary footer has the following text:
      | You can withdraw this contract offer if you need to. Use the button below which will withdraw the offer made to the supplier and close the procurement. |

  Scenario: Contract summary return links
    Then I click on the 'Return to procurements dashboard' return link
    And I am on the 'Procurements dashboard' page
    Then I navigate to the contract 'Sent contract' in 'Sent offers'
    Then I click on the 'Return to procurements dashboard' back link
    And I am on the 'Procurements dashboard' page

  @contract_emails
  Scenario: Close sent procurement
    Then I click on 'Close this procurement'
    And I am on the 'Are you sure you wish to close' page
    And I enter the reason for closing the contract:
      | The procurement is no longer required |
    Then I click on 'Close this procurement'
    Then I am on the 'Your procurement has been closed' page
    And I click on 'Return to procurements dashboard'
    Then I am on the 'Procurements dashboard' page
    Then I navigate to the contract 'Sent contract' in 'Closed'
    Then there is a warning with the text 'Closed'
    And the key details include:
      | You closed this contract offer on |
    And the reason for closing is:
      | The procurement is no longer required |
    And I should see the following text within the contract offer history:
      | You sent this contract offer to the supplier on           |
    And the contract summary footer has the following text:
      | If you wish to reuse this procurement’s requirements in a new/similar procurement, or further competition, please click on the button below to create a copy and save under a new contract name.  |
