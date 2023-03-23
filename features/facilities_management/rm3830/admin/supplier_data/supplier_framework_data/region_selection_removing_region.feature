Feature: Removing regions for suppliers on the admin tool

  Background:
    Given I sign in as an admin and navigate to the 'RM3830' dashboard

  Scenario: Deselecting a service for lot 1a
    Given I go to a quick view with the following services and regions:
      | C.1 | UKD3  |
      | C.2 |       |
    Then 'Bode and Sons' is a supplier in Sub-lot '1a'
    Given I go to the admin dashboard for 'RM3830'
    And I click on 'Supplier framework data'
    Then I am on the 'Supplier framework data' page
    And select 'Regions' for sublot '1a' for 'Bode and Sons'
    Then I am on the 'Sub-lot 1a regions' page
    And I deselect the following items:
      | Greater Manchester  |
    And I click on 'Save and return to supplier framework data'
    Then I am on the 'Supplier framework data' page
    Then I go to a quick view with the following services and regions:
      | C.1 | UKD3  |
      | C.2 |       |
    And 'Bode and Sons' is not a supplier in Sub-lot '1a'

  Scenario: Deselecting a service for lot 1b
    Given I go to a quick view with the following services and regions:
      | C.1 | UKH1  |
      | C.2 |       |
    Then 'Dickens and Sons' is a supplier in Sub-lot '1b'
    Given I go to the admin dashboard for 'RM3830'
    And I click on 'Supplier framework data'
    Then I am on the 'Supplier framework data' page
    And select 'Regions' for sublot '1b' for 'Dickens and Sons'
    Then I am on the 'Sub-lot 1b regions' page
    And I deselect the following items:
      | East Anglia |
    And I click on 'Save and return to supplier framework data'
    Then I am on the 'Supplier framework data' page
    Then I go to a quick view with the following services and regions:
      | C.1 | UKH1  |
      | C.2 |       |
    And 'Dickens and Sons' is not a supplier in Sub-lot '1b'

  Scenario: Deselecting a service for lot 1c
    Given I go to a quick view with the following services and regions:
      | C.1 | UKK1  |
      | C.2 |       |
    Then 'Mann Group' is a supplier in Sub-lot '1c'
    Given I go to the admin dashboard for 'RM3830'
    And I click on 'Supplier framework data'
    Then I am on the 'Supplier framework data' page
    And select 'Regions' for sublot '1c' for 'Mann Group'
    Then I am on the 'Sub-lot 1c regions' page
    And I deselect the following items:
      | Gloucestershire, Wiltshire and Bristol/Bath area  |
    And I click on 'Save and return to supplier framework data'
    Then I am on the 'Supplier framework data' page
    Then I go to a quick view with the following services and regions:
      | C.1 | UKK1  |
      | C.2 |       |
    And 'Mann Group' is not a supplier in Sub-lot '1c'
