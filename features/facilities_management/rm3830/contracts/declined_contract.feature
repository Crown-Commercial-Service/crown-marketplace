Feature: Declined contract

  Background: The contract I sent has been declined
    Given I sign in and navigate to my account for 'RM3830'
    And I have a contract that has been 'declined' called 'Declined contract'
    And I click on 'Continue a procurement'
    Then I navigate to the contract 'Declined contract' in 'Sent offers'
  
  Scenario: Contract declined
    Then there is a warning with the text 'Declined'
    And the key details include:
      | The supplier declined this offer  |
    And the reason for declining is:
      | I cannot be bothered with it  |
    And I should see the following text within the contract offer history:
      | You sent this contract offer to the supplier  |
    And the contract summary footer has the following text:
      | You can look at the next lowest priced supplier and the option of offering them your contract. Click on the ‘View next supplier’s price’ button below.                  |
      | or                                                                                                                                                                      |
      | You can close this procurement by clicking on the ‘Close this procurement’ button below, it will then be viewable in the closed section of your procurements dashboard. |

  Scenario: Contract summary return links
    Then I click on the 'Return to procurements dashboard' return link
    And I am on the 'Procurements dashboard' page
    Then I navigate to the contract 'Declined contract' in 'Sent offers'
    Then I click on the 'Return to procurements dashboard' back link
    And I am on the 'Procurements dashboard' page

  @contract_emails
  Scenario: Contract declined - send to next supplier
    Then I click on "View next supplier's price"
    And I am on the 'Offer to next supplier' page
    And I click on 'Confirm and send offer to supplier'
    Then I am on the 'Your contract was sent' page
    And I click on 'Return to procurements dashboard'
    Then I am on the 'Procurements dashboard' page
    And there is contract named 'Declined contract' in 'Sent offers'
    Then I navigate to the contract 'Declined contract' in 'Closed'
    Then there is a warning with the text 'Closed'
    And the key details include:
      | The contract offer was automatically closed when you offered the procurement to the next supplier |
    And I should see the following text within the contract offer history:
      | The supplier declined this contract offer on    |
      | You sent this contract offer to the supplier on |
    And the reason for declining is:
      | I cannot be bothered with it  |
    And the contract summary footer has the following text:
      | If you wish to reuse this procurement’s requirements in a new/similar procurement, or further competition, please click on the button below to create a copy and save under a new contract name.  |

  Scenario: Contract declined - close procurement
    Then I click on 'Close this procurement'
    And I am on the 'Are you sure you wish to close' page
    And I enter the reason for closing the contract:
      | The suppliers would not respond |
      | I did not have enough time      |
    Then I click on 'Close this procurement'
    Then I am on the 'Your procurement has been closed' page
    And I click on 'Return to procurements dashboard'
    Then I am on the 'Procurements dashboard' page
    Then I navigate to the contract 'Declined contract' in 'Closed'
    Then there is a warning with the text 'Closed'
    And the key details include:
      | You closed this contract offer on |
    And the reason for closing is:
      | The suppliers would not respond |
      | I did not have enough time      |
    And I should see the following text within the contract offer history:
      | The supplier declined this contract offer       |
      | You sent this contract offer to the supplier on |
    And the reason for declining is:
      | I cannot be bothered with it  |
    And the contract summary footer has the following text:
      | If you wish to reuse this procurement’s requirements in a new/similar procurement, or further competition, please click on the button below to create a copy and save under a new contract name.  |
