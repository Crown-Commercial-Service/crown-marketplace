@accessibility @javascript
Feature: Accessibility statement accessibility

  Scenario: Accessibility statement
    Given I go to the admin dashboard for 'RM3830'
    When I click on 'Accessibility statement'
    Then I am on the 'Facilities Management (FM) Accessibility statement' page
    Then the page should be axe clean
