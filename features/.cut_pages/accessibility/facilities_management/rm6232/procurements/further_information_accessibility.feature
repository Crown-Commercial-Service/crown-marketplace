@accessibility @javascript
Feature: What do I do next? accessibility

  Scenario: What do I do next? is accessible
    Given I sign in and navigate to my account for 'RM6232'
    Given I have a completed procurement for further information named 'My completed procurement'
    When I navigate to the procurement 'My completed procurement'
    And I am on the 'What do I do next' page
    Then the page should be axe clean
