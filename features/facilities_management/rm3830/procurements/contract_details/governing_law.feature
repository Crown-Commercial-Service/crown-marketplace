Feature: Governing law

  Background: Navigate to the Governing law question
    Given I sign in and navigate to my account for 'RM3830'
    And I have a procurement in DA draft at the 'contract_details' stage named 'Governing law procurement'
    When I navigate to the procurement 'Governing law procurement'
    Then I am on the 'Contract details' page
    And I answer the 'Governing law' contract detail question
    Then I am on the 'Governing law' page

  Scenario: Answer is saved
    Given I pick 'English Law' for the governing law
    And I click on 'Save and continue'
    Then I am on the 'Contract details' page
    And my answer to the 'Governing law' contract detail question is 'English Law'

  Scenario: Can change answer
    Given I pick 'Scottish Law' for the governing law
    And I click on 'Save and continue'
    Then I am on the 'Contract details' page
    And my answer to the 'Governing law' contract detail question is 'Scottish Law'
    And I answer the 'Governing law' contract detail question
    Then I am on the 'Governing law' page
    When I pick 'Northern Ireland Law' for the governing law
    And I click on 'Save and continue'
    Then I am on the 'Contract details' page
    And my answer to the 'Governing law' contract detail question is 'Northern Ireland Law'

  Scenario: Return links work
    Given I click on the 'Return to contract details' back link
    Then I am on the 'Contract details' page
    Then I answer the 'Governing law' contract detail question
    And I am on the 'Governing law' page
    When I click on the 'Return to contract details' return link
    Then I am on the 'Contract details' page