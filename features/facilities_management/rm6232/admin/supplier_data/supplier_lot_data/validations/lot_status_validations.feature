Feature: Changing the lot status validations

  Scenario: Validate supplier status
    Given I sign in as an admin and navigate to the 'RM6232' dashboard
    And I have an inactive supplier called 'Colony Iota INC.'
    And I click on 'Supplier data'
    Then I am on the 'Supplier data' page
    Then I click on 'View lot data' for 'Colony Iota INC.'
    And I am on the 'View lot data' page
    And the supplier name shown is 'Colony Iota INC.'
    And I change the 'lot status' for lot '1a'
    Then I am on the 'Lot 1a status' page
    And I click on 'Save and return'
    Then I should see the following error messages:
      | You must select a status for the lot data |
