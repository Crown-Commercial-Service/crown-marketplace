Feature: Removing services for suppliers on the admin tool

  Background:
    Given I sign in as an admin and navigate to the 'RM3830' dashboard

  Scenario: Deselecting a service for lot 1a
    Given I go to a quick view with the following services and regions:
      | C.1 | UKC1  |
      |     | UKC2  |
    Then 'Abernathy and Sons' is a supplier in Sub-lot '1a'
    Given I go to the admin dashboard for 'RM3830'
    And I click on 'Supplier framework data'
    Then I am on the 'Supplier framework data' page
    And select 'Services' for sublot '1a' for 'Abernathy and Sons'
    Then I am on the 'Sub-lot 1a services, prices, and variances' page
    And I deselect the following items:
      | C.1 Mechanical and electrical engineering maintenance |
    And I click on 'Save and return to supplier framework data'
    Then I am on the 'Supplier framework data' page
    Then I go to a quick view with the following services and regions:
      | C.1 | UKC1  |
      |     | UKC2  |
    And 'Abernathy and Sons' is not a supplier in Sub-lot '1a'

  Scenario: Deselecting a service for lot 1b
    Given I go to a quick view with the following services and regions:
      | D.2 | UKI6  |
      |     | UKI7  |
    Then 'Treutel LLC' is a supplier in Sub-lot '1b'
    Given I go to the admin dashboard for 'RM3830'
    And I click on 'Supplier framework data'
    Then I am on the 'Supplier framework data' page
    And select 'Services' for sublot '1b' for 'Treutel LLC'
    Then I am on the 'Sub-lot 1b services' page
    And I deselect the following items:
      | D.2 Tree surgery (arboriculture)  |
    And I click on 'Save and return to supplier framework data'
    Then I am on the 'Supplier framework data' page
    Then I go to a quick view with the following services and regions:
      | D.2 | UKI6  |
      |     | UKI7  |
    And 'Treutel LLC' is not a supplier in Sub-lot '1b'

  Scenario: Deselecting a service for lot 1c
    Given I go to a quick view with the following services and regions:
      | K.1 | UKC1  |
      |     | UKC2  |
    Then 'Dickens and Sons' is a supplier in Sub-lot '1c'
    Given I go to the admin dashboard for 'RM3830'
    And I click on 'Supplier framework data'
    Then I am on the 'Supplier framework data' page
    And select 'Services' for sublot '1c' for 'Dickens and Sons'
    Then I am on the 'Sub-lot 1c services' page
    And I deselect the following items:
      | K.1 Classified waste  |
    And I click on 'Save and return to supplier framework data'
    Then I am on the 'Supplier framework data' page
    Then I go to a quick view with the following services and regions:
      | K.1 | UKC1  |
      |     | UKC2  |
    And 'Dickens and Sons' is not a supplier in Sub-lot '1c'
