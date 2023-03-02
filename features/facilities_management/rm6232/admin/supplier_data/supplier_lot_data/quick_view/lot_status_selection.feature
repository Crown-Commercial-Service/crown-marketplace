Feature: Changing the lot status for suppliers on the admin tool and seeing the effect on the results

  Background: Sign in and navigate to the admin dashboard
    Given I sign in as an admin and navigate to the 'RM6232' dashboard

  Scenario Outline: Total services - lot status
    Given I go to a quick view with the following services, regions and annual contract cost:
      | F.1  | UKH1  | <contract_value>  |
      | K.1  | UKH2  |                   |
    Then I should be in sub-lot '<lot_number>'
    And I 'should' see the supplier "<supplier_name>" in the results
    Given I go to the admin dashboard for 'RM6232'
    And I click on 'Supplier data'
    Then I am on the 'Supplier data' page
    And I click on 'View lot data' for '<supplier_name>'
    Then I am on the 'View lot data' page
    And I change the 'lot status' for lot '<lot_number>'
    Then I am on the 'Lot <lot_number> status' page
    And the supplier name shown is '<supplier_name>'
    And I select 'INACTIVE' for the lot status
    And I click on 'Save and return'
    And I am on the 'View lot data' page
    Given I go to a quick view with the following services, regions and annual contract cost:
      | F.1  | UKH1  | <contract_value>  |
      | K.1  | UKH2  |                   |
    Then I should be in sub-lot '<lot_number>'
    And I 'should not' see the supplier "<supplier_name>" in the results

    Examples:
      | contract_value  | lot_number  | supplier_name                 |
      | 500000          | 1a          | Sawayn, Abbott and Huels      |
      | 2000000         | 1b          | Zboncak and Sons              |
      | 11000000        | 1c          | Cummerata, Lubowitz and Ebert |


  Scenario Outline: Hard services - lot status
    Given I go to a quick view with the following services, regions and annual contract cost:
      | F.2  | UKL18  | <contract_value>  |
      | N.10 | UKL24  |                   |
    Then I should be in sub-lot '<lot_number>'
    And I 'should' see the supplier "<supplier_name>" in the results
    Given I go to the admin dashboard for 'RM6232'
    And I click on 'Supplier data'
    Then I am on the 'Supplier data' page
    And I click on 'View lot data' for '<supplier_name>'
    Then I am on the 'View lot data' page
    And I change the 'lot status' for lot '<lot_number>'
    Then I am on the 'Lot <lot_number> status' page
    And the supplier name shown is '<supplier_name>'
    And I select 'INACTIVE' for the lot status
    And I click on 'Save and return'
    And I am on the 'View lot data' page
    Given I go to a quick view with the following services, regions and annual contract cost:
      | F.2  | UKL18  | <contract_value>  |
      | N.10 | UKL24  |                   |
    Then I should be in sub-lot '<lot_number>'
    And I 'should not' see the supplier "<supplier_name>" in the results

    Examples:
      | contract_value  | lot_number  | supplier_name             |
      | 500000          | 2a          | Harber LLC                |
      | 2000000         | 2b          | Lind, Stehr and Dickinson |
      | 11000000        | 2c          | Breitenberg-Mante         |

  Scenario Outline: Soft services - lot status
    Given I go to a quick view with the following services, regions and annual contract cost:
      | H.1  | UKH3  | <contract_value>  |
      | I.5  | UKK4  |                   |
    Then I should be in sub-lot '<lot_number>'
    And I 'should' see the supplier "<supplier_name>" in the results
    Given I go to the admin dashboard for 'RM6232'
    And I click on 'Supplier data'
    Then I am on the 'Supplier data' page
    And I click on 'View lot data' for "<supplier_name>"
    Then I am on the 'View lot data' page
    And I change the 'lot status' for lot '<lot_number>'
    Then I am on the 'Lot <lot_number> status' page
    And the supplier name shown is "<supplier_name>"
    And I select 'INACTIVE' for the lot status
    And I click on 'Save and return'
    And I am on the 'View lot data' page
    Given I go to a quick view with the following services, regions and annual contract cost:
      | H.1  | UKH3  | <contract_value>  |
      | I.5  | UKK4  |                   |
    Then I should be in sub-lot '<lot_number>'
    And I 'should not' see the supplier "<supplier_name>" in the results

    Examples:
      | contract_value  | lot_number  | supplier_name                   |
      | 500000          | 3a          | O'Reilly, Emmerich and Reichert |
      | 2000000         | 3b          | Howell, Sanford and Shanahan    |
      | 11000000        | 3c          | Muller Inc                      |
