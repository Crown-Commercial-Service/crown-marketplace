Feature: Procurements Dashboard

  Scenario: Navigate to procurements page
    Given I sign in and navigate to my account
    And I click on 'Continue a procurement'
    Then I am on the 'Procurements dashboard' page
    And I should see the following secondary headings:
      | Searches            |
      | Direct award        |
      | Further competition |