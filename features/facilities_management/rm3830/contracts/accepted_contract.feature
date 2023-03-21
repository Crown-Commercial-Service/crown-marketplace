Feature: Accepeted contract

  Background: The contract I sent has been accepted
    Given I sign in and navigate to my account for 'RM3830'
    And I have a contract that has been 'accepted' called 'Accepted contract'
    And I click on 'Continue a procurement'
    Then I navigate to the contract 'Accepted contract' in 'Sent offers'

  Scenario: Review the accepted contract
    Then there is a warning with the text 'Accepted, awaiting contract signature'
    And the key details include:
      | Awaiting your confirmation of signed contract.  |
    And I should see the following text within the contract offer history:
      | The supplier accepted the contract offer      |
      | You sent this contract offer to the supplier  |
    And the what happens next 'details' titles are:
      | 1. Supplier signs the contract      |
      | 2. You sign the contract            |
      | 3. Confirmation of signed contract  |
    And the contract summary footer has the following text:
      | Use the ‘confirm if contract signed or not’ button below to confirm whether or not the contract was signed.                                                                             |
      | You can still withdraw this contract offer; if you need to, use the ‘Close this procurement’ button below, which will withdraw the offer from the supplier, and close the procurement.  |

  Scenario: Contract summary return links
    Then I click on the 'Return to procurements dashboard' return link
    And I am on the 'Procurements dashboard' page
    Then I navigate to the contract 'Accepted contract' in 'Sent offers'
    Then I click on the 'Return to procurements dashboard' back link
    And I am on the 'Procurements dashboard' page
    Then I navigate to the contract 'Accepted contract' in 'Sent offers'
    Then I click on 'Confirm if contract signed or not'
    And I am on the 'Confirmation of signed contract' page
    And I click on 'Cancel'
    Then I am on the 'Contract summary' page

  @contract_emails
  Scenario: The contract is signed
    Then I click on 'Confirm if contract signed or not'
    And I am on the 'Confirmation of signed contract' page
    And I select 'Yes' for the confirmation of signed contract
    And I enter a contract start date 2 years and 0 months into the future
    And I enter a contract end date 5 years and 0 months into the future
    And I click on 'Save and continue'
    Then I am on the 'Contract signed' page
    And the contract dates are correct on the contract signed page
    Then I click on 'Return to procurements dashboard'
    And the contract dates are correct for 'Accepted contract' on the procurement dashboard
    Then I navigate to the contract 'Accepted contract' in 'Contracts'
    Then there is a warning with the text 'Accepted and signed'
    And the contract dates are correct on the contract summary page
    And I should see the following text within the contract offer history:
      | the contract has been signed by both parties. |
      | The supplier accepted the contract offer      |
      | You sent this contract offer to the supplier  |
    And the contract summary footer has the following text:
      | If you wish to reuse this procurement’s requirements in a new/similar procurement, or further competition, please click on the button below to create a copy and save under a new contract name.  |

  @contract_emails
  Scenario: The contract is not signed and sent to the next supplier
    Then I click on 'Confirm if contract signed or not'
    And I am on the 'Confirmation of signed contract' page
    And I select 'No' for the confirmation of signed contract
    And I enter the reason for not signing:
      | It could not be done  |
      | not even for £5       |
    Then I click on 'Save and continue'
    And I am on the 'Contract summary' page
    Then there is a warning with the text 'Accepted, not signed'
    And the key details include:
      | the contract has not been signed  |
    And the reason for not signing is:
      | It could not be done  |
      | not even for £5       |
    And I should see the following text within the contract offer history:
      | The supplier accepted the contract offer        |
      | You sent this contract offer to the supplier on |
    And the contract summary footer has the following text:
      | You can look at the next lowest priced supplier and the option of offering them your contract. Click on the ‘View next supplier’s price’ button below.                  |
      | or                                                                                                                                                                      |
      | You can close this procurement by clicking on the ‘Close this procurement’ button below, it will then be viewable in the closed section of your procurements dashboard. |
    Then I click on "View next supplier's price"
    And I am on the 'Offer to next supplier' page
    And I click on 'Confirm and send offer to supplier'
    Then I am on the 'Your contract was sent' page
    And I click on 'Return to procurements dashboard'
    Then I am on the 'Procurements dashboard' page
    And there is contract named 'Accepted contract' in 'Sent offers'
    Then I navigate to the contract 'Accepted contract' in 'Closed'
    Then there is a warning with the text 'Closed'
    And the key details include:
      | The contract offer was automatically closed when you offered the procurement to the next supplier |
    And I should see the following text within the contract offer history:
      | the contract has not been signed.               |
      | The supplier accepted the contract offer        |
      | You sent this contract offer to the supplier on |
    And the reason for not signing is:
      | It could not be done  |
      | not even for £5       |
    And the contract summary footer has the following text:
      | If you wish to reuse this procurement’s requirements in a new/similar procurement, or further competition, please click on the button below to create a copy and save under a new contract name.  |

  @contract_emails
  Scenario: Contract not signed return link
    Then I click on 'Confirm if contract signed or not'
    And I am on the 'Confirmation of signed contract' page
    And I select 'No' for the confirmation of signed contract
    And I enter the reason for not signing:
      | Here is my reason |
    Then I click on 'Save and continue'
    And I am on the 'Contract summary' page
    Then I click on "View next supplier's price"
    And I am on the 'Offer to next supplier' page
    Then I click on 'Cancel and return to contract summary'
    And I am on the 'Contract summary' page
    Then I click on "View next supplier's price"
    And I am on the 'Offer to next supplier' page
    Then I click on the 'Back' back link
    And I am on the 'Contract summary' page
    Then I click on "View next supplier's price"
    And I am on the 'Offer to next supplier' page
    Then I click on 'Return to procurements dashboard'
    And I am on the 'Procurements dashboard' page

  @contract_emails
  Scenario: The contract is not signed and the procurement is closed
    Then I click on 'Confirm if contract signed or not'
    And I am on the 'Confirmation of signed contract' page
    And I select 'No' for the confirmation of signed contract
    And I enter the reason for not signing:
      | The supplier did not respond to me  |
    Then I click on 'Save and continue'
    And I am on the 'Contract summary' page
    Then there is a warning with the text 'Accepted, not signed'
    And the key details include:
      | the contract has not been signed  |
    And the reason for not signing is:
      | The supplier did not respond to me  |
    And I should see the following text within the contract offer history:
      | The supplier accepted the contract offer        |
      | You sent this contract offer to the supplier on |
    And the contract summary footer has the following text:
      | You can look at the next lowest priced supplier and the option of offering them your contract. Click on the ‘View next supplier’s price’ button below.                  |
      | or                                                                                                                                                                      |
      | You can close this procurement by clicking on the ‘Close this procurement’ button below, it will then be viewable in the closed section of your procurements dashboard. |
    Then I click on 'Close this procurement'
    And I am on the 'Are you sure you wish to close' page
     And I enter the reason for closing the contract:
      | I did not have enough time      |
      | The suppliers would not respond |
    Then I click on 'Close this procurement'
    Then I am on the 'Your procurement has been closed' page
    And I click on 'Return to procurements dashboard'
    Then I am on the 'Procurements dashboard' page
    Then I navigate to the contract 'Accepted contract' in 'Closed'
    Then there is a warning with the text 'Closed'
    And the key details include:
      | You closed this contract offer on |
    And the reason for closing is:
      | I did not have enough time      |
      | The suppliers would not respond |
    And I should see the following text within the contract offer history:
      | the contract has not been signed.               |
      | The supplier accepted the contract offer        |
      | You sent this contract offer to the supplier on |
    And the reason for not signing is:
      | The supplier did not respond to me  |
    And the contract summary footer has the following text:
      | If you wish to reuse this procurement’s requirements in a new/similar procurement, or further competition, please click on the button below to create a copy and save under a new contract name.  |
