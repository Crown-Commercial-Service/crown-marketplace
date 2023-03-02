Feature: Supplier name

  Background: Sign in
    Given I sign in as an admin and navigate to the 'RM6232' dashboard

  Scenario: Changing the name is saved
    And I click on 'Supplier data'
    Then I am on the 'Supplier data' page
    Then I click on 'View details' for 'Abshire, Schumm and Farrell'
    And I am on the 'Supplier details' page
    And the supplier name on the details page is 'Abshire, Schumm and Farrell'
    And I change the 'Supplier name' for the supplier details
    Then I am on the 'Supplier name' page
    And I enter 'The Argentum trade guild' into the 'Supplier name' field
    And I click on 'Save and return'
    Then I am on the 'Supplier details' page
    And the 'Supplier name' is 'The Argentum trade guild' on the supplier details page

  Scenario Outline: Change supplier name changes in results
    Given I go to a quick view with the following services, regions and annual contract cost:
      | E.2  | UKE2  | 123456 |
      | O.1  | UKE4  |        |
    And I 'should' see the supplier '<supplier_name>' in the results
    Given I go to the admin dashboard for 'RM6232'
    And I click on 'Supplier data'
    Then I am on the 'Supplier data' page
    And I click on 'View details' for '<supplier_name>'
    Then I am on the 'Supplier details' page
    And I change the 'Supplier name' for the supplier details
    Then I am on the 'Supplier name' page
    And I enter 'New supplier' into the 'Supplier name' field
    And I click on 'Save and return'
    Then I am on the 'Supplier details' page
    Given I go to a quick view with the following services, regions and annual contract cost:
      | E.2  | UKE2  | 123456 |
      | O.1  | UKE4  |        |
    Then I 'should not' see the supplier '<supplier_name>' in the results 
    And I 'should' see the supplier 'New supplier' in the results

    Examples:
      | supplier_name   |
      | Feest Group     |
      | Okuneva-Fritsch |
      | Torphy Inc      |

