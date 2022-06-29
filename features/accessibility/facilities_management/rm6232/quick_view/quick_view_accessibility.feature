@accessibility @javascript
Feature: Results accessibility

  Background: Navigate to select services
    Given I sign in and navigate to my account for 'RM6232'
    And I click on 'Search for suppliers'
    Then I am on the 'Start a procurement' page

  Scenario: Start a procurement page
    Then the page should be axe clean

  Scenario: Select services page
    And I click on 'Continue'
    Then I am on the 'Services' page
    And I show all sections
    Then the page should be axe clean

  Scenario: Select regions page
    And I click on 'Continue'
    Then I am on the 'Services' page
    And I show all sections
    Then I select the following items:
      | Mechanical and Electrical Engineering Maintenance           |
      | Planned / Group re-lamping service                          |
      | Building Information Modelling and Government Soft Landings |
    And I click on 'Continue'
    Then I am on the 'Regions' page
    And I show all sections
    Then the page should be axe clean

  Scenario: Annual contract value page
    And I click on 'Continue'
    Then I am on the 'Services' page
    And I show all sections
    Then I select the following items:
      | Mechanical and Electrical Engineering Maintenance           |
      | Planned / Group re-lamping service                          |
      | Building Information Modelling and Government Soft Landings |
    And I click on 'Continue'
    Then I am on the 'Regions' page
    And I show all sections
    Then I select the following items:
      | Tees Valley and Durham  |
      | Essex                   |
    And I click on 'Continue'
    Then I am on the 'Annual contract value' page
    Then the page should be axe clean

  Scenario: Restuls page
    And I click on 'Continue'
    Then I am on the 'Services' page
    And I show all sections
    Then I select the following items:
      | Mechanical and Electrical Engineering Maintenance           |
      | Planned / Group re-lamping service                          |
      | Building Information Modelling and Government Soft Landings |
    And I click on 'Continue'
    Then I am on the 'Regions' page
    And I show all sections
    Then I select the following items:
      | Tees Valley and Durham  |
      | Essex                   |
    And I click on 'Continue'
    Then I am on the 'Annual contract value' page
    And I enter '123456' for the annual contract value
    And I click on 'Continue'
    Then I am on the 'Results' page
    Then the page should be axe clean
