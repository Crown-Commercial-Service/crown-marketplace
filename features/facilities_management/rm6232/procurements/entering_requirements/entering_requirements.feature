Feature: Entering requirements

  Background: I navigate to the Entering requirements page
    Given I sign in and navigate to my account for 'RM6232'
    Given I have a completed procurement for entering requirements named 'My completed procurement'
    When I navigate to the procurement 'My completed procurement'
    And I am on the 'Further service and contract requirements' page
  
  Scenario: The content is correct
    And the procurement name is shown to be 'My completed procurement'
    And everything is completed

  @pipeline
  Scenario: I can continue to 'Results'
    And I click on 'Save and continue'
    Then I am on the 'Results' page

  Scenario: Back button link
    And I click on 'Return to procurements dashboard'
    Then I am on the 'Procurements dashboard' page

  Scenario: Return link
    And I click on 'Return to your account'
    And I am on the Your account page
