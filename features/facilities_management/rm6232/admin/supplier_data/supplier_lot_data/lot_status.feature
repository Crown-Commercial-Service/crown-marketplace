Feature: Changing the lot status

  Background: I navigate to the supplier data page
    Given I sign in as an admin and navigate to the 'RM6232' dashboard
    And I click on 'Supplier data'
    Then I am on the 'Supplier data' page

  Scenario Outline: I can got to all lots and change the status
    Then I click on 'View lot data' for '<supplier_name>'
    And I am on the 'View lot data' page
    And I change the 'lot status' for lot '<lot>'
    Then I am on the 'Lot <lot> status' page
    And the supplier name shown is '<supplier_name>'

    Examples:
      | supplier_name                 | lot |
      | Donnelly, Wiegand and Krajcik | 1b  |
      | Schulist-Wuckert              | 2a  |
      | Zboncak and Sons              | 3c  |

  Scenario Outline: I change the status and it changes on View lot data
    Then I click on 'View lot data' for '<supplier_name>'
    And I am on the 'View lot data' page
    And the status is 'ACTIVE' for lot '<lot>'
    And I change the 'lot status' for lot '<lot>'
    Then I am on the 'Lot <lot> status' page
    And the supplier name shown is '<supplier_name>'
    And I select 'INACTIVE' for the lot status
    And I click on 'Save and return'
    And I am on the 'View lot data' page
    And the status is 'INACTIVE' for lot '<lot>'

    Examples:
      | supplier_name                 | lot |
      | Donnelly, Wiegand and Krajcik | 1b  |
      | Schulist-Wuckert              | 2a  |
      | Zboncak and Sons              | 3c  |

  Scenario Outline: Breadcrumb links work from lot status
    Then I click on 'View lot data' for 'Yost LLC'
    And I am on the 'View lot data' page
    And I change the 'lot status' for lot '1c'
    Then I am on the 'Lot 1c status' page
    And the supplier name shown is 'Yost LLC'
    And I click on '<link_text>'
    Then I am on the '<page_title>' page

    Examples:
      | link_text     | page_title                      |
      | Home          | RM6232 administration dashboard |
      | Supplier data | Supplier data                   |
      | View lot data | View lot data                   |
