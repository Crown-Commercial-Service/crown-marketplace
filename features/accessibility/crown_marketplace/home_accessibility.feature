@javascript @accessibility
Feature: Home - accessibility

  Scenario: Home page
    Given I sign in as an 'user support' user go to the crown marketplace dashboard
    And the page should be axe clean
