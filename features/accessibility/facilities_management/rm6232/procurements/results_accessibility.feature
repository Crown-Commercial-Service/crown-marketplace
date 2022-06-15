@accessibility @javascript
Feature: What happens next accessibility

  Scenario: What happens next page is accessible
    Given I sign in and navigate to my account for 'RM6232'
    Given I have a completed procurement for results named 'My completed procurement'
    When I navigate to the procurement 'My completed procurement'
    And I am on the 'Results' page
    Then the page should be axe clean
