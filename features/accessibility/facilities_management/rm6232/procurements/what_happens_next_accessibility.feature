@accessibility @javascript
Feature: What happens next accessibility

  Scenario: What happens next page is accessible
    Given I sign in and navigate to my account for 'RM6232'
    And I have a procurement with the name 'My WHN procurement'
    When I navigate to the procurement 'My WHN procurement'
    And I am on the 'What happens next?' page
    Then the page should be axe clean
