Feature: Changing the supplier details and seeing how they affect procurements

  Background: I sign in and have procurements
    Given I sign in as an admin and navigate to the 'RM3830' dashboard
    And I have direct award procurements

  Scenario: Changing the supplier details and checking DA procuremnets
    And I go to the buyer dashboard
    And I click on 'Continue a procurement'
    And I click on 'Contract sent'
    Then I am on the 'Contract summary' page
    And the supplier name is 'Abernathy and Sons'
    And the supplier details are:
      | Name: Drema Alvin                                 |
      | Telephone: 01440 603986                           |
      | abernathy-and-sons@yopmail.com                    |
      | Address: 2 Thirteenth Avenue, Liversedge WF15 8LG |
    Given I go to the admin dashboard for 'RM3830'
    And I click on 'Supplier details'
    Then I am on the 'Supplier details' page
    And I click on 'Abernathy and Sons'
    Then I am on the 'Supplier details' page
    When I change the 'Supplier name' for the supplier details
    Then I am on the 'Supplier name' page
    And I enter 'The Argentum trade guild' into the 'Supplier name' field
    And I click on 'Save and return'
    And I am on the 'Supplier details' page
    When I change the 'Contact name' for the supplier details
    And I am on the 'Supplier contact information' page
    Given I enter 'Bana' into the 'Contact name' field
    And I enter 'argentum.enquiries@noppontrade.com' into the 'Contact email' field
    And I enter '01603 456 871' into the 'Contact telephone number' field
    And I click on 'Save and return'
    Then I am on the 'Supplier details' page
    When I change the 'Full address' for the supplier details
    Then I am on the 'Supplier address' page
    And I enter the following details into the form:
      | Building and street | Goldmouth Warehouse |
      | Town or city        | Argentum            |
      | Postcode            | AA1 1AA             |
    And I click on 'Save and return'
    Then I am on the 'Supplier details' page
    Given I go to the buyer dashboard
    And I click on 'Continue a procurement'
    And I click on 'Contract sent'
    Then I am on the 'Contract summary' page
    And the supplier name is 'The Argentum trade guild'
    And the supplier details are:
      | Name: Bana                                      |
      | Telephone: 01603 456 871                        |
      | argentum.enquiries@noppontrade.com              |
      | Address: Goldmouth Warehouse, Argentum AA1 1AA  |

  Scenario: Changing the supplier and checking the supplier account
    Given I logout and sign in the supplier 'abernathy-and-sons@yopmail.com'
    Then I should see the following contracts on the dashboard in the section:
      | Received offers | Contract sent     |
      | Accepted offers | Contract accepted |
      | Contracts       | Contract signed   |
      | Closed          | Contract declined |
    Given I sign out and sign in the admin user
    And I click on 'Supplier details'
    Then I am on the 'Supplier details' page
    And I click on 'Abernathy and Sons'
    Then I am on the 'Supplier details' page
    And I change the 'Current user' for the supplier details
    Then I am on the 'Supplier user account' page
    Given I enter the user email into the user email field
    And I click on 'Save and return'
    Then I am on the 'Supplier details' page
    And I navigate to the supplier dashboard
    Then I should see the following contracts on the dashboard in the section:
      | Received offers | Contract sent     |
      | Accepted offers | Contract accepted |
      | Contracts       | Contract signed   |
      | Closed          | Contract declined |
    Given I logout and sign in the supplier again
    Then I should not see any contracts
