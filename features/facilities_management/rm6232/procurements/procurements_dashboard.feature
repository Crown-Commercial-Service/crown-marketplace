Feature: Procurements Dashboard

  Scenario: Navigate to procurements page
    Given I sign in and navigate to my account for 'RM6232'
    And I click on 'View your saved searches'
    Then I am on the 'Procurements dashboard' page
    And I should see the following secondary headings:
      | Searches                        |
      | Advanced procurement activities |
