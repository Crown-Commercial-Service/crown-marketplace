Feature: Payment method validations

  Scenario: Nothing selected on payment method
    Given I sign in and navigate to my account for 'RM3830'
    And I have a procurement in DA draft at the 'contract_details' stage named 'Payment method procurement'
    When I navigate to the procurement 'Payment method procurement'
    Then I am on the 'Contract details' page
    And I answer the 'Payment method' contract detail question
    Then I am on the 'Payment method' page
    And I click on 'Save and return'
    Then I should see the following error messages:
      | Select one payment method |
