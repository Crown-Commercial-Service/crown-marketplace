Feature: What happens next

  Background: I navigate to the What happens next page
    Given I sign in and navigate to my account for 'RM6232'
    And I have an empty procurement for 'what_happens_next' named 'My WHN procurement'
    When I navigate to the procurement 'My WHN procurement'
    And I am on the 'What happens next?' page
  
  Scenario: The content is correct
    And the procurement name is shown to be 'My WHN procurement'
    And the contract number is visible

  @pipeline
  Scenario: I can download the spreadsheet
    And I click on 'Selected suppliers'
    Then the spreadsheet 'Supplier shortlist (My WHN procurement)' is downloaded

  @pipeline
  Scenario: I can continue to 'Further service and contract requirements'
    And I click on 'Save and continue'
    Then I am on the 'Further service and contract requirements' page

  Scenario: Back button link
    And I click on 'Return to procurements dashboard'
    Then I am on the 'Procurements dashboard' page

  Scenario: Return link
    And I click on 'Return to your account'
    And I am on the Your account page
