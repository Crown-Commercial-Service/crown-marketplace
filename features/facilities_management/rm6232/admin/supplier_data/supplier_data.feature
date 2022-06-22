@pipeline
Feature: Supplier data pages

  Background: Admin signs in
    Given I sign in as an admin and navigate to the 'RM6232' dashboard
    And I click on 'Supplier data'
    Then I am on the 'Supplier data' page

  @javascript
  Scenario: Supplier data page
    Then I should see all the suppliers
    And I enter "ha" for the supplier search
    Then I should see the following suppliers on the page:
      | Glover, Koepp and Rohan   |
      | Haag LLC                  |
      | Hansen-Mante              |
      | Lehner, Bosco and Kuphal  |
      | Runolfsdottir-Hane        |
      | Schaden Inc               |
    And I enter "" for the supplier search
    Then I should see all the suppliers

  Scenario Outline: View lot data
    Then I click on 'View lot data' for '<supplier_name>'
    And I am on the 'View lot data' page
    And the supplier name shown is '<supplier_name>'
    And they have services and regions for the following lots '<lots>'

    Examples:
      | supplier_name   | lots                    |
      | Cremin-Hegmann  | 3a                      |
      | Ritchie-Turner  | 1a, 2a, 1b, 2b          |
      | Gottlieb Group  | 1a, 2a, 3a, 1b, 2b, 3b  |

  Scenario Outline: View details
    Then I click on 'View details' for '<supplier_name>'
    And I am on the 'Supplier details' page
    And the supplier name on the details page is '<supplier_name>'
  
    Examples:
      | supplier_name               |
      | Bode-Wisoky                 |
      | Fahey, Kuhlman and Reichert |
      | Schuster-Lemke              |
