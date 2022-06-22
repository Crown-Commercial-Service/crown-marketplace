Feature: Removing services for suppliers on the admin tool and seeing the effect on the results

  Background: Sign in and navigate to the admin dashboard
    Given I sign in as an admin and navigate to the 'RM6232' dashboard

  Scenario Outline: Total services - service selection
    Given I go to a quick view with the following services, regions and annual contract value:
      | F.1  | UKH1  | <contract_value>  |
      | K.2  | UKH2  |                   |
    Then I should be in sub-lot '<lot_number>'
    And I 'should' see the supplier "<supplier_name>" in the results
    Given I go to the admin dashboard for 'RM6232'
    And I click on 'Supplier data'
    Then I am on the 'Supplier data' page
    And I click on 'View lot data' for '<supplier_name>'
    Then I am on the 'View lot data' page
    Then I change the 'services' for lot '<lot_number>'
    Then I am on the 'Lot <lot_number> services' page
    And I deselect the following items:
      | Taxi booking Service  |
    And I click on 'Save and return'
    Then I am on the 'View lot data' page
    Given I go to a quick view with the following services, regions and annual contract value:
      | F.1  | UKH1  | <contract_value>  |
      | K.2  | UKH2  |                   |
    Then I should be in sub-lot '<lot_number>'
    And I 'should not' see the supplier "<supplier_name>" in the results

    Examples:
      | contract_value  | lot_number  | supplier_name   |
      | 500000          | 1a          | Berge and Sons  |
      | 2000000         | 1b          | Schuster-Lemke  |
      | 11000000        | 1c          | Kiehn-Leannon   |

  @pipeline
  Scenario Outline: Hard services - service selection
    Given I go to a quick view with the following services, regions and annual contract value:
      | F.2   | UKL18 | <contract_value>  |
      | N.10  | UKL24 |                   |
    Then I should be in sub-lot '<lot_number>'
    And I 'should' see the supplier "<supplier_name>" in the results
    Given I go to the admin dashboard for 'RM6232'
    And I click on 'Supplier data'
    Then I am on the 'Supplier data' page
    And I click on 'View lot data' for '<supplier_name>'
    Then I am on the 'View lot data' page
    Then I change the 'services' for lot '<lot_number>'
    Then I am on the 'Lot <lot_number> services' page
    And I deselect the following items:
      | Housing and residential accommodation management  |
    And I click on 'Save and return'
    Then I am on the 'View lot data' page
    Given I go to a quick view with the following services, regions and annual contract value:
      | F.2   | UKL18  | <contract_value>  |
      | N.10  | UKL24  |                   |
    Then I should be in sub-lot '<lot_number>'
    And I 'should not' see the supplier "<supplier_name>" in the results

    Examples:
      | contract_value  | lot_number  | supplier_name       |
      | 500000          | 2a          | Hansen-Mante        |
      | 2000000         | 2b          | Runolfsdottir-Hane  |
      | 11000000        | 2c          | Brekke-Zemlak       |

  Scenario Outline: Soft services - service selection
    Given I go to a quick view with the following services, regions and annual contract value:
      | H.2  | UKH3  | <contract_value>  |
      | I.9  | UKK4  |                   |
    Then I should be in sub-lot '<lot_number>'
    And I 'should' see the supplier "<supplier_name>" in the results
    Given I go to the admin dashboard for 'RM6232'
    And I click on 'Supplier data'
    Then I am on the 'Supplier data' page
    And I click on 'View lot data' for '<supplier_name>'
    Then I am on the 'View lot data' page
    Then I change the 'services' for lot '<lot_number>'
    Then I am on the 'Lot <lot_number> services' page
    And I deselect the following items:
      | Cleaning of communications and equipment rooms  |
    And I click on 'Save and return'
    Then I am on the 'View lot data' page
    Given I go to a quick view with the following services, regions and annual contract value:
      | H.2  | UKH3  | <contract_value>  |
      | I.9  | UKK4  |                   |
    Then I should be in sub-lot '<lot_number>'
    And I 'should not' see the supplier "<supplier_name>" in the results

    Examples:
      | contract_value  | lot_number  | supplier_name               |
      | 500000          | 3a          | Fahey, Kuhlman and Reichert |
      | 2000000         | 3b          | Schuster-Lemke              |
      | 11000000        | 3c          | Murray Group                |
