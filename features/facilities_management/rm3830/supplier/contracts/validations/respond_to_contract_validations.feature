Feature: Supplier respond to contract offer validations

  Background: Navigate to respond to the contract offer
    Given I log in as a supplier with a contract in 'sent' named 'Sent contract'
    And I click on 'Sent contract'
    Then I am on the 'Contract summary' page
    Then I click on 'Respond to this offer'
    And I am on the 'Respond to the contract offer' page
  
  Scenario: Nothing is selected
    When I click on 'Confirm and continue'
    Then I should see the following error messages:
      | You must select one option to respond to the contract offer |

  Scenario: No is selected with not input
    And I respond to this contract offer with 'No'
    When I click on 'Confirm and continue'
    Then I should see the following error messages:
      | Enter a reason for declining this contract offer |
