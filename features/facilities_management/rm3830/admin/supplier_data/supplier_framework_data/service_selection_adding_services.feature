Feature: Adding services for suppliers on the admin tool

  Background:
    Given I sign in as an admin and navigate to the 'RM3830' dashboard

  Scenario: Selecting a service for lot 1a
    Given I go to a quick view with the following services and regions:
      | D.3 | UKC1  |
      |     | UKC2  |
    Then 'Shields, Ratke and Parisian' is not a supplier in Sub-lot '1a'
    Given I go to the admin dashboard for 'RM3830'
    And I click on 'Supplier framework data'
    Then I am on the 'Supplier framework data' page
    Given I show all sections
    And select 'Services' for sublot '1a' for 'Shields, Ratke and Parisian'
    Then I am on the 'Sub-lot 1a services, prices, and variances' page
    And I select the following items:
      | D.3 Professional snow & ice clearance |
    And I click on 'Save and return to supplier framework data'
    Then I am on the 'Supplier framework data' page
    Then I go to a quick view with the following services and regions:
      | D.3 | UKC1  |
      |     | UKC2  |
    And 'Shields, Ratke and Parisian' is a supplier in Sub-lot '1a'

  Scenario: Selecting a service for lot 1b
    Given I go to a quick view with the following services and regions:
      | L.5 | UKC1  |
      |     | UKC2  |
    Then 'Rowe, Hessel and Heller' is not a supplier in Sub-lot '1b'
    Given I go to the admin dashboard for 'RM3830'
    And I click on 'Supplier framework data'
    Then I am on the 'Supplier framework data' page
    Given I show all sections
    And select 'Services' for sublot '1b' for 'Rowe, Hessel and Heller'
    Then I am on the 'Sub-lot 1b services' page
    And I select the following items:
      | L.5 Flag flying service |
    And I click on 'Save and return to supplier framework data'
    Then I am on the 'Supplier framework data' page
    Then I go to a quick view with the following services and regions:
      | L.5 | UKC1  |
      |     | UKC2  |
    And 'Rowe, Hessel and Heller' is a supplier in Sub-lot '1b'

  Scenario: Selecting a service for lot 1c
    Given I go to a quick view with the following services and regions:
      | F.3 | UKC1  |
      |     | UKC2  |
    Then 'Mayert, Kohler and Schowalter' is not a supplier in Sub-lot '1c'
    Given I go to the admin dashboard for 'RM3830'
    And I click on 'Supplier framework data'
    Then I am on the 'Supplier framework data' page
    Given I show all sections
    And select 'Services' for sublot '1c' for 'Mayert, Kohler and Schowalter'
    Then I am on the 'Sub-lot 1c services' page
    And I select the following items:
      | F.3 Deli/coffee bar |
    And I click on 'Save and return to supplier framework data'
    Then I am on the 'Supplier framework data' page
    Then I go to a quick view with the following services and regions:
      | F.3 | UKC1  |
      |     | UKC2  |
    And 'Mayert, Kohler and Schowalter' is a supplier in Sub-lot '1c'