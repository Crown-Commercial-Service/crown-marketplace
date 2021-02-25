@accessibility @javascript
Feature: Contract details accessibility

  Background: Navigate to the contract details page
    Given I sign in and navigate to my account
    And I have a procurement with completed contract details named 'Contract detail procurement'
    When I navigate to the procurement 'Contract detail procurement'
    Then I am on the 'Contract details' page

  Scenario: Completed contract details page
    Then the page should be axe clean

  Scenario: With secuirty policy document
    And I answer the 'Security policy' contract detail question
    Then I am on the 'Security policy document' page
    And I select 'Yes' for the security policy document question
    And I enter 'Test' for the security policy document 'name'
    And I enter '12' for the security policy document 'number'
    And I upload security policy document that is 'valid'
    When I click on 'Save and return'
    Then I am on the 'Contract details' page
    Then the page should be axe clean
