Feature: Supplier details

  Background: Navigate to the additional supplier information section
    Given I sign in as an admin and navigate to the 'RM6232' dashboard
    And I click on 'Supplier data'
    Then I am on the 'Supplier data' page
    Then I click on 'View details' for 'Zboncak and Sons'
    And I am on the 'Supplier details' page
    And the supplier name on the details page is 'Zboncak and Sons'

  Scenario Outline: Supplier details breadcrumbs
    Given I click on '<text>'
    Then I am on the '<page>' page

    Examples:
      | text          | page                            |
      | Home          | RM6232 administration dashboard |
      | Supplier data | Supplier data                   |

  Scenario: Return links on pages
    And I change the '<supplier_detail>' for the supplier details
    Then I am on the '<current_page>' page
    Given I click on '<text>'
    Then I am on the 'Supplier details' page

    Examples:
      | supplier_detail | current_page                    | text                                      |
      | Supplier status | Supplier status                 | Zboncak and Sons                          |
      | Supplier status | Supplier status                 | Cancel and return to the supplier details |
      | Supplier name   | Supplier name                   | Zboncak and Sons                          |
      | Supplier name   | Supplier name                   | Cancel and return to the supplier details |
      | DUNS number     | Additional supplier information | Zboncak and Sons                          |
      | DUNS number     | Additional supplier information | Cancel and return to the supplier details |
      | Full address    | Supplier address                | Zboncak and Sons                          |
      | Full address    | Supplier address                | Cancel and return to the supplier details |
