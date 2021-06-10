@accessibility @javascript
Feature: Supplier framework data - accessibility

  Background: Navigate to the supplier
    Given I sign in as an admin and navigate to my dashboard
    And I click on 'Supplier framework data'
    Then I am on the 'Supplier framework data' page
    Given I open all sections

  Scenario: Supplier framework data page
    Then the page should be axe clean

  Scenario: Service pages 1a
    And select 'Services' for sublot '1a' for 'Cartwright and Sons'
    Then I am on the 'Sub-lot 1a services, prices, and variances' page
    Then the page should be axe clean

  Scenario: Service pages 1b
    And select 'Services' for sublot '1b' for 'Graham-Farrell'
    Then I am on the 'Sub-lot 1b services' page
    Then the page should be axe clean

  Scenario: Service pages 1c
    And select 'Services' for sublot '1c' for 'Smitham-Brown'
    Then I am on the 'Sub-lot 1c services' page
    Then the page should be axe clean

  Scenario: Region pages 1a
    And select 'Regions' for sublot '1a' for 'Cartwright and Sons'
    Then I am on the 'Sub-lot 1a regions' page
    Then the page should be axe clean

  Scenario: Region pages 1b
    And select 'Regions' for sublot '1b' for 'Graham-Farrell'
    Then I am on the 'Sub-lot 1b regions' page
    Then the page should be axe clean

  Scenario: Region pages 1c
    And select 'Regions' for sublot '1c' for 'Smitham-Brown'
    Then I am on the 'Sub-lot 1c regions' page
    Then the page should be axe clean
