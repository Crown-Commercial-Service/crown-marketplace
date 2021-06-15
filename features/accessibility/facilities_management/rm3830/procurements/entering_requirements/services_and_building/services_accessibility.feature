@accessibility @javascript
Feature: Services accessibility

  Background: Navigate to the service page
    Given I sign in and navigate to my account for 'RM3830'
    And I have an empty procurement for entering requirements named 'My services procurement'
    When I navigate to the procurement 'My services procurement'
    Then I am on the 'Requirements' page
    And I click on 'Services'
    Then I am on the 'Services' page

  Scenario: Services page
    Then the page should be axe clean

  Scenario: Services summary page
    Given I open all sections
    And I select 'Building management system (BMS) maintenance'
    When I click on 'Save and continue'
    Then I am on the 'Services summary' page
    And the page should be axe clean