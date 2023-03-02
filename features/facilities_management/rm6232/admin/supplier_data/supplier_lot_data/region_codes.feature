Feature: Selecting region codes

  Background: I navigate to the supplier data page
    Given I sign in as an admin and navigate to the 'RM6232' dashboard
    And I click on 'Supplier data'
    Then I am on the 'Supplier data' page

  Scenario Outline: I can got to all lots and change the regions
    Then I click on 'View lot data' for '<supplier_name>'
    And I am on the 'View lot data' page
    And I change the 'regions' for lot '<lot>'
    Then I am on the '<title>' page
    And the supplier name shown is '<supplier_name>'

    Examples:
      | supplier_name               | lot | title           |
      | Abshire, Schumm and Farrell | 1a  | Lot 1a regions  |
      | Terry-Greenholt             | 2b  | Lot 2b regions  |
      | Schultz-Wilkinson           | 3c  | Lot 3c regions  |

  Scenario: I change the regions and it changes on View lot data - lot 1a
    Then I click on 'View lot data' for 'Brakus, Lueilwitz and Blanda'
    And I am on the 'View lot data' page
    And I change the 'regions' for lot '1a'
    Then I am on the 'Lot 1a regions' page
    And the supplier name shown is 'Brakus, Lueilwitz and Blanda'
    And I deselect all checkboxes
    And I select the following items:
      | South Yorkshire                                               |
      | Surrey, East and West Sussex                                  |
      | South West Wales (Ceredigion, Carmarthenshire, Pembrokeshire) |
    And I click on 'Save and return'
    And I am on the 'View lot data' page
    And I should see the following regions selected for lot '1a':
      | South Yorkshire                                               |
      | Surrey, East and West Sussex                                  |
      | South West Wales (Ceredigion, Carmarthenshire, Pembrokeshire) |    

  Scenario: I change the regions and it changes on View lot data - lot 2b
    Then I click on 'View lot data' for 'Donnelly, Wiegand and Krajcik'
    And I am on the 'View lot data' page
    And I change the 'regions' for lot '2b'
    Then I am on the 'Lot 2b regions' page
    And the supplier name shown is 'Donnelly, Wiegand and Krajcik'
    And I deselect all checkboxes
    And I select the following items:
      | Essex                                             |
      | Gloucestershire, Wiltshire and Bristol/Bath area  |
    And I click on 'Save and return'
    And I am on the 'View lot data' page
    And I should see the following regions selected for lot '2b':
      | Essex                                             |
      | Gloucestershire, Wiltshire and Bristol/Bath area  | 

  Scenario: I change the regions and it changes on View lot data - lot 3c
    Then I click on 'View lot data' for 'Lind, Stehr and Dickinson'
    And I am on the 'View lot data' page
    And I change the 'regions' for lot '3c'
    Then I am on the 'Lot 3c regions' page
    And the supplier name shown is 'Lind, Stehr and Dickinson'
    And I deselect all checkboxes
    And I select the following items:
      | Tees Valley and Durham  |
      | North Yorkshire         |
      | Inner London - East     |
      | Powys                   |
      | Falkirk                 |
      | Belfast                 |
    And I click on 'Save and return'
    And I am on the 'View lot data' page
    And I should see the following regions selected for lot '3c':
      | Tees Valley and Durham  |
      | North Yorkshire         |
      | Inner London - East     |
      | Powys                   |
      | Falkirk                 |
      | Belfast                 |

  Scenario Outline: Breadcrumb links work from regions
    Then I click on 'View lot data' for 'Yost LLC'
    And I am on the 'View lot data' page
    And I change the 'regions' for lot '1c'
    Then I am on the 'Lot 1c regions' page
    And the supplier name shown is 'Yost LLC'
    And I click on '<link_text>'
    Then I am on the '<page_title>' page

    Examples:
      | link_text     | page_title                      |
      | Home          | RM6232 administration dashboard |
      | Supplier data | Supplier data                   |
      | View lot data | View lot data                   |
