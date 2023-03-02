Feature: Payment method

  Background: Navigate to the Payment method question
    Given I sign in and navigate to my account for 'RM3830'
    And I have a procurement in DA draft at the 'contract_details' stage named 'Payment method procurement'
    When I navigate to the procurement 'Payment method procurement'
    Then I am on the 'Contract details' page
    And I answer the 'Payment method' contract detail question
    Then I am on the 'Payment method' page

  Scenario: Answer is saved
    Given I pick 'BACS payment' for the payment method
    And I click on 'Save and return'
    Then I am on the 'Contract details' page
    And my answer to the 'Payment method' contract detail question is 'BACS payment'

  Scenario: Can change answer
    Given I pick 'BACS payment' for the payment method
    And I click on 'Save and return'
    Then I am on the 'Contract details' page
    And my answer to the 'Payment method' contract detail question is 'BACS payment'
    And I answer the 'Payment method' contract detail question
    Then I am on the 'Payment method' page
    When I pick 'Government procurement card' for the payment method
    And I click on 'Save and return'
    Then I am on the 'Contract details' page
    And my answer to the 'Payment method' contract detail question is 'Government procurement card'

  Scenario: Return links work
    Given I click on the 'Return to contract details' back link
    Then I am on the 'Contract details' page
    Then I answer the 'Payment method' contract detail question
    And I am on the 'Payment method' page
    When I click on the 'Return to contract details' return link
    Then I am on the 'Contract details' page