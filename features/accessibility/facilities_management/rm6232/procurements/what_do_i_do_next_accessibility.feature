@accessibility @javascript
Feature: What do I do next accessibility

  Scenario: What do I do next page is accessible
    Given I sign in and navigate to my account for 'RM6232'
    And I have a procurement with the name 'My WDIDN procurement'
    When I navigate to the procurement 'My WDIDN procurement'
    And I am on the 'What do I do next?' page
    Then the page should be axe clean
