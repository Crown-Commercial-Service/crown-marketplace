Feature: Adding services for suppliers on the admin tool and seeing the effect on the results

  Background: Sign in and navigate to the admin dashboard
    Given I sign in as an admin and navigate to the 'RM6232' dashboard

  Scenario Outline: Total services - service selection
    Given I go to a quick view with the following services, regions and annual contract cost:
      | E.2 | UKE2 | <contract_value> |
      | O.1 | UKE4 |                  |
    Then I should be in sub-lot '<lot_number>'
    And I 'should not' see the supplier "<supplier_name>" in the results
    Given I go to the admin dashboard for 'RM6232'
    And I click on 'Supplier data'
    Then I am on the 'Supplier data' page
    And I click on 'View lot data' for '<supplier_name>'
    Then I am on the 'View lot data' page
    Then I change the 'services' for lot '<lot_number>'
    Then I am on the 'Lot <lot_number> services' page
    And I select the following items:
      | End-User Accommodation Services |
    And I click on 'Save and return'
    Then I am on the 'View lot data' page
    Given I go to a quick view with the following services, regions and annual contract cost:
      | E.2 | UKE2 | <contract_value> |
      | O.1 | UKE4 |                  |
    Then I should be in sub-lot '<lot_number>'
    And I 'should' see the supplier "<supplier_name>" in the results

    Examples:
      | contract_value | lot_number | supplier_name                |
      | 500000         | 1a         | Brakus, Lueilwitz and Blanda |
      | 2000000        | 1b         | Miller, Walker and Leffler   |
      | 11000000       | 1c         | Schultz-Wilkinson            |

  Scenario Outline: Hard services - service selection
    Given I go to a quick view with the following services, regions and annual contract cost:
      | E.6 | UKD1 | <contract_value> |
      | E.9 | UKI3 |                  |
    Then I should be in sub-lot '<lot_number>'
    And I 'should not' see the supplier "<supplier_name>" in the results
    Given I go to the admin dashboard for 'RM6232'
    And I click on 'Supplier data'
    Then I am on the 'Supplier data' page
    And I click on 'View lot data' for "<supplier_name>"
    Then I am on the 'View lot data' page
    Then I change the 'services' for lot '<lot_number>'
    Then I am on the 'Lot <lot_number> services' page
    And I select the following items:
      | Planned / Group re-lamping service |
    And I click on 'Save and return'
    Then I am on the 'View lot data' page
    Given I go to a quick view with the following services, regions and annual contract cost:
      | E.6 | UKD1 | <contract_value> |
      | E.9 | UKI3 |                  |
    Then I should be in sub-lot '<lot_number>'
    And I 'should' see the supplier "<supplier_name>" in the results

    Examples:
      | contract_value | lot_number | supplier_name           |
      | 500000         | 2a         | Schulist-Wuckert        |
      | 2000000        | 2b         | Blick, O'Kon and Larkin |
      | 11000000       | 2c         | Berge-Koepp             |

  Scenario Outline: Soft services - service selection
    Given I go to a quick view with the following services, regions and annual contract cost:
      | I.2 | UKD1 | <contract_value> |
      | G.3 | UKI3 |                  |
    Then I should be in sub-lot '<lot_number>'
    And I 'should not' see the supplier "<supplier_name>" in the results
    Given I go to the admin dashboard for 'RM6232'
    And I click on 'Supplier data'
    Then I am on the 'Supplier data' page
    And I click on 'View lot data' for '<supplier_name>'
    Then I am on the 'View lot data' page
    Then I change the 'services' for lot '<lot_number>'
    Then I am on the 'Lot <lot_number> services' page
    And I select the following items:
      | Tree Surgery (Arboriculture) |
    And I click on 'Save and return'
    Then I am on the 'View lot data' page
    Given I go to a quick view with the following services, regions and annual contract cost:
      | I.2 | UKD1 | <contract_value> |
      | G.3 | UKI3 |                  |
    Then I should be in sub-lot '<lot_number>'
    And I 'should' see the supplier "<supplier_name>" in the results

    Examples:
      | contract_value | lot_number | supplier_name               |
      | 500000         | 3a         | Abshire, Schumm and Farrell |
      | 2000000        | 3b         | Zboncak and Sons            |
      | 11000000       | 3c         | Swift, Friesen and Predovic |
