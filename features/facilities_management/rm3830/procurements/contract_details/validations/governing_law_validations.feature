Feature: Governing law validations

  Scenario: Nothing selected on governing law
    Given I sign in and navigate to my account for 'RM3830'
    And I have a procurement in DA draft at the 'contract_details' stage named 'Governing law procurement'
    When I navigate to the procurement 'Governing law procurement'
    Then I am on the 'Contract details' page
    And I answer the 'Governing law' contract detail question
    Then I am on the 'Governing law' page
    And I click on 'Save and continue'
    Then I should see the following error messages:
      | Select one option |
