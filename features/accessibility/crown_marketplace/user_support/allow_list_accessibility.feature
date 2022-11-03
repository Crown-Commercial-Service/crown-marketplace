@allow_list @javascript @accessibility
Feature: Allow list - User support - accessibility

  Scenario: Allow list page
    Given I sign in as an 'user support' user go to the crown marketplace dashboard
    # When I click on 'Allow list'
    # Then I am on the 'Allow list' page
    And the page should be axe clean
