Feature: Supplier name

  Background: Sign in
    Given I sign in as an admin and navigate to the 'RM3830' dashboard

  Scenario: Changing the name is saved
    And I click on 'Supplier details'
    Then I am on the 'Supplier details' page
    And I click on 'Abbott-Dooley'
    Then I am on the 'Supplier details' page
    And I change the 'Supplier name' for the supplier details
    Then I am on the 'Supplier name' page
    And I enter 'The Argentum trade guild' into the 'Supplier name' field
    And I click on 'Save and return'
    Then I am on the 'Supplier details' page
    And the 'Supplier name' is 'The Argentum trade guild' on the supplier details page

  Scenario Outline: Change supplier name changes in results
    Given I go to a quick view with the following services and regions:
      | C.1 | UKD3  |
      | C.2 |       |
    Then '<supplier_name>' is a supplier in Sub-lot '1a'
    Given I go to the admin dashboard
    And I click on 'Supplier details'
    Then I am on the 'Supplier details' page
    And I click on '<supplier_name>'
    Then I am on the 'Supplier details' page
    And I change the 'Supplier name' for the supplier details
    Then I am on the 'Supplier name' page
    And I enter 'New supplier' into the 'Supplier name' field
    And I click on 'Save and return'
    Then I am on the 'Supplier details' page
    Then I go to a quick view with the following services and regions:
      | C.1 | UKD3  |
      | C.2 |       |
    Then '<supplier_name>' is not a supplier in Sub-lot '1a'
    And 'New supplier' is a supplier in Sub-lot '1a'
  
    Examples:
      | supplier_name           |
      | Cartwright and Sons     |
      | Dare, Heaney and Kozey  |
      | Wolf-Wiza               |
