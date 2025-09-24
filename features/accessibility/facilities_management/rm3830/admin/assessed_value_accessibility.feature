@accessibility @javascript
Feature: Assessed value - accessibility

  Background: Navigate to the dashboard
    Given I sign in as an admin and navigate to the 'RM3830' dashboard

  Scenario: Average framework rates page
    And I click on 'Average framework rates'
    Then I am on the 'Average framework rates' page
    Then the page should be axe clean

  Scenario: Call-off benchmark rates page
    And I click on 'Call-off benchmark rates'
    Then I am on the 'Call-off benchmark rates' page
    Then the page should be axe clean
