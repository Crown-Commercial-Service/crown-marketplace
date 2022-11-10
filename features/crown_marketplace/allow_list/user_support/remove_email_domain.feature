@allow_list @pipeline
Feature: Allow list - User support - Remove email domain

  Scenario: I cannot remove an email domain
    Given I sign in as an 'user support' user go to the crown marketplace dashboard
    When I click on 'Allow list'
    Then I am on the 'Allow list' page
    And the following email domains are in the list:
      | email.com   |
      | example.com |
      | test.com    |
    And I cannot remove an email domain
