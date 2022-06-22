Feature: Adding regions for suppliers on the admin tool and seeing the effect on the results

  Background: Sign in and navigate to the admin dashboard
    Given I sign in as an admin and navigate to the 'RM6232' dashboard

  Scenario Outline: Total services - region selection
    Given I go to a quick view with the following services, regions and annual contract value:
      | E.16  | UKC1  | <contract_value>  |
      | M.3   | UKN01 |                   |
    Then I should be in sub-lot '<lot_number>'
    And I 'should not' see the supplier "<supplier_name>" in the results
    Given I go to the admin dashboard for 'RM6232'
    And I click on 'Supplier data'
    Then I am on the 'Supplier data' page
    And I click on 'View lot data' for '<supplier_name>'
    Then I am on the 'View lot data' page
    Then I change the 'regions' for lot '<lot_number>'
    Then I am on the 'Lot <lot_number> regions' page
    And I select the following items:
      | Belfast |
    And I click on 'Save and return'
    Then I am on the 'View lot data' page
    Given I go to a quick view with the following services, regions and annual contract value:
      | E.16  | UKC1  | <contract_value>  |
      | M.3   | UKN01 |                   |
    Then I should be in sub-lot '<lot_number>'
    And I 'should' see the supplier "<supplier_name>" in the results

    Examples:
      | contract_value  | lot_number  | supplier_name     |
      | 500000          | 1a          | Stracke and Sons  |
      | 2000000         | 1b          | Schaden Inc       |

  Scenario Outline: Hard services - region selection
    Given I go to a quick view with the following services, regions and annual contract value:
      | E.6 | UKD1  | <contract_value>  |
      | F.2 | UKM21 |                   |
    Then I should be in sub-lot '<lot_number>'
    And I 'should not' see the supplier "<supplier_name>" in the results
    Given I go to the admin dashboard for 'RM6232'
    And I click on 'Supplier data'
    Then I am on the 'Supplier data' page
    And I click on 'View lot data' for '<supplier_name>'
    Then I am on the 'View lot data' page
    Then I change the 'regions' for lot '<lot_number>'
    Then I am on the 'Lot <lot_number> regions' page
    And I select the following items:
      | Angus and Dundee  |
    And I click on 'Save and return'
    Then I am on the 'View lot data' page
    Given I go to a quick view with the following services, regions and annual contract value:
      | E.6 | UKD1  | <contract_value>  |
      | F.2 | UKM21 |                   |
    Then I should be in sub-lot '<lot_number>'
    And I 'should' see the supplier "<supplier_name>" in the results

    Examples:
      | contract_value  | lot_number  | supplier_name     |
      | 500000          | 2a          | Stracke and Sons  |
      | 2000000         | 2b          | Wyman LLC         |
      | 11000000        | 2c          | Ratke LLC         |

  @pipeline
  Scenario Outline: Soft services - region selection
    Given I go to a quick view with the following services, regions and annual contract value:
      | G.5 | UKD6  | <contract_value>  |
      | J.1 | UKM65 |                   |
    Then I should be in sub-lot '<lot_number>'
    And I 'should not' see the supplier "<supplier_name>" in the results
    Given I go to the admin dashboard for 'RM6232'
    And I click on 'Supplier data'
    Then I am on the 'Supplier data' page
    And I click on 'View lot data' for '<supplier_name>'
    Then I am on the 'View lot data' page
    Then I change the 'regions' for lot '<lot_number>'
    Then I am on the 'Lot <lot_number> regions' page
    And I select the following items:
      | Orkney Islands  |
    And I click on 'Save and return'
    Then I am on the 'View lot data' page
    Given I go to a quick view with the following services, regions and annual contract value:
      | G.5 | UKD6  | <contract_value>  |
      | J.1 | UKM65 |                   |
    Then I should be in sub-lot '<lot_number>'
    And I 'should' see the supplier "<supplier_name>" in the results

    Examples:
      | contract_value  | lot_number  | supplier_name               |
      | 500000          | 3a          | Stracke and Sons            |
      | 2000000         | 3b          | Kirlin Inc                  |
