Feature: Results

  Background: I navigate to the Entering requirements page
    Given I sign in and navigate to my account for 'RM6232'
    Given I have a completed procurement for results named 'My completed procurement'
    When I navigate to the procurement 'My completed procurement'
    And I am on the 'Results' page

  Scenario: The content is correct
    And the procurement name is shown to be 'My completed procurement'
    And my sublot is '2a'
    And I have 2 buildings in my results
    And I have 2 services in my results

  # @pipeline
  # Scenario: I can continue to 'Further competition'
  #   And I click on 'Save and continue'
  #   Then I am on the 'Results' page

  @pipeline
  Scenario: I can change my requirements
    And I click on 'Change requirements'
    Then I am on the 'Further service and contract requirements' page
    And everything is completed

  Scenario: Back button link
    And I click on 'Return to procurements dashboard'
    Then I am on the 'Procurements dashboard' page

  Scenario: Return link
    And I click on 'Return to your account'
    And I am on the Your account page
