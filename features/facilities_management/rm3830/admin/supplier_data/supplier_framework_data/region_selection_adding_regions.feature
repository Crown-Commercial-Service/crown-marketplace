Feature: Adding regions for suppliers on the admin tool

  Background:
    Given I sign in as an admin and navigate to the 'RM3830' dashboard

  Scenario: Selecting a service for lot 1a
    Given I go to a quick view with the following services and regions:
      | C.1 | UKC2  |
      | C.2 |       |
    Then 'Cartwright and Sons' is not a supplier in Sub-lot '1a'
    Given I go to the admin dashboard
    And I click on 'Supplier framework data'
    Then I am on the 'Supplier framework data' page
    And select 'Regions' for sublot '1a' for 'Cartwright and Sons'
    Then I am on the 'Sub-lot 1a regions' page
    And I select the following items:
      | Northumberland and Tyne and Wear  |
    And I click on 'Save and return to supplier framework data'
    Then I am on the 'Supplier framework data' page
    Then I go to a quick view with the following services and regions:
      | C.1 | UKC2  |
      | C.2 |       |
    And 'Cartwright and Sons' is a supplier in Sub-lot '1a'

  @pipeline
  Scenario: Selecting a service for lot 1b
    Given I go to a quick view with the following services and regions:
      | C.1 | UKH1  |
      | C.2 |       |
    Then 'Hickle-Schinner' is not a supplier in Sub-lot '1b'
    Given I go to the admin dashboard
    And I click on 'Supplier framework data'
    Then I am on the 'Supplier framework data' page
    And select 'Regions' for sublot '1b' for 'Hickle-Schinner'
    Then I am on the 'Sub-lot 1b regions' page
    And I select the following items:
      | East Anglia |
    And I click on 'Save and return to supplier framework data'
    Then I am on the 'Supplier framework data' page
    Then I go to a quick view with the following services and regions:
      | C.1 | UKH1  |
      | C.2 |       |
    And 'Hickle-Schinner' is a supplier in Sub-lot '1b'

  Scenario: Selecting a service for lot 1c
    Given I go to a quick view with the following services and regions:
      | C.1 | UKM65 |
      | C.2 |       |
    Then 'Krajcik-Gibson' is not a supplier in Sub-lot '1c'
    Given I go to the admin dashboard
    And I click on 'Supplier framework data'
    Then I am on the 'Supplier framework data' page
    And select 'Regions' for sublot '1c' for 'Krajcik-Gibson'
    Then I am on the 'Sub-lot 1c regions' page
    And I select the following items:
      | Orkney Islands  |
    And I click on 'Save and return to supplier framework data'
    Then I am on the 'Supplier framework data' page
    Then I go to a quick view with the following services and regions:
      | C.1 | UKM65 |
      | C.2 |       |
    And 'Krajcik-Gibson' is a supplier in Sub-lot '1c'