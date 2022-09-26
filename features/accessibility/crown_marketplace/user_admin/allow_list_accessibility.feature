@allow_list @javascript @accessibility
Feature: Allow list - User admin - accessibility

  Background: Sign in and navigate to the allow list page
    Given I sign in as an 'user admin' user go to the crown marketplace dashboard
    # When I click on 'Allow list'
    # Then I am on the 'Allow list' page

  Scenario: Allow list page
    And the page should be axe clean

  Scenario: Add email domain page
    And I click on 'Add a new email domain'
    Then I am on the 'Add an email domain' page
    And the page should be axe clean

  Scenario: Remove email domain page
    And I click on remove for 'example.com'
    Then I am on the "Are you sure you want to remove 'example.com' from the Allow list?" page
    And the page should be axe clean
