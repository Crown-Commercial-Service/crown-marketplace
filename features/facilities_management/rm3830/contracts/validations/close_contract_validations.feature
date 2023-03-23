Feature: Close contract - validations

  Scenario: No reason for closing
    Given I sign in and navigate to my account for 'RM3830'
    And I have a contract that has been 'declined' called 'Declined contract'
    And I click on 'Continue a procurement'
    Then I navigate to the contract 'Declined contract' in 'Sent offers'
    Then I click on 'Close this procurement'
    And I am on the 'Are you sure you wish to close' page
    And I click on 'Close this procurement'
    Then I should see the following error messages:
      | Enter a reason for closing this procurement |