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
      | Conn, Hayes and Lakin        |
      | Harber LLC                   |
      | Harris LLC                   |
      | Howell, Sanford and Shanahan |
      | Rohan-Windler                |
    And I enter "" for the supplier search
    Then I should see all the suppliers

  Scenario Outline: View lot data
    Then I click on 'View lot data' for '<supplier_name>'
    And I am on the 'View lot data' page
    And the supplier name shown is '<supplier_name>'
    And they have services and regions for the following lots '<lots>'

    Examples:
      | supplier_name               | lots                   |
      | Abshire, Schumm and Farrell | 1a, 2a, 3a, 1b, 2b, 3b |
      | Schultz-Wilkinson           | 1c, 2c, 3c             |
      | Terry-Greenholt             | 1b, 2b, 3b, 1c, 2c, 3c |

  Scenario Outline: View details
    Then I click on 'View details' for '<supplier_name>'
    And I am on the 'Supplier details' page
    And the supplier name on the details page is '<supplier_name>'

    Examples:
      | supplier_name               |
      | Bins, Yost and Donnelly     |
      | Feest Group                 |
      | Swift, Friesen and Predovic |
