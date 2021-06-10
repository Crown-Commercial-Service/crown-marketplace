Feature: No more suppliers

  Scenario: There are no more suppliers
    Given I sign in and navigate to my account for 'RM3830'
    And I have a contract that has been 'declined' called 'No more suppliers' and there are no more suppliers
    And I click on 'Continue a procurement'
    Then I navigate to the contract 'No more suppliers' in 'Sent offers'
    Then I click on "View next supplier's price"
    And I am on the 'Supplier shortlist' page
    Then I click on 'Return to procurements dashboard'
    Then I navigate to the contract 'No more suppliers' in 'Closed'
    Then there is a warning with the text 'Closed'
    And the key details include:
      | when you tried to offer the procurement to the next supplier, but there were no more suppliers. |
    And I should see the following text within the contract offer history:
      | The supplier declined this contract offer       |
      | You sent this contract offer to the supplier on |
    And the reason for declining is:
      | I cannot be bothered with it  |
    And the contract summary footer has the following text:
      | If you wish to reuse this procurement’s requirements in a new/similar procurement, or further competition, please click on the button below to create a copy and save under a new contract name.  |
