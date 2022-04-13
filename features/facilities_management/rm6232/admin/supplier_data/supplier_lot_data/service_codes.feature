Feature: Selecting service codes

  Background: I navigate to the supplier data page
    Given I sign in as an admin and navigate to the 'RM6232' dashboard
    And I click on 'Supplier data'
    Then I am on the 'Supplier data' page

  Scenario Outline: I can got to all lots and change the services
    Then I click on 'View lot data' for '<supplier_name>'
    And I am on the 'View lot data' page
    And I change the 'services' for lot '<lot>'
    Then I am on the '<title>' page
    And the supplier name shown is '<supplier_name>'

    Examples:
      | supplier_name               | lot | title           |
      | Abshire, Schumm and Farrell | a   | Lot a services  |
      | Terry-Greenholt             | b   | Lot b services  |
      | Schultz-Wilkinson           | c   | Lot c services  |

  Scenario: I change the services and it changes on View lot data - lot a
    Then I click on 'View lot data' for 'Conn, Hayes and Lakin'
    And I am on the 'View lot data' page
    And I change the 'services' for lot 'a'
    Then I am on the 'Lot a services' page
    And the supplier name shown is 'Conn, Hayes and Lakin'
    And I deselect all checkboxes
    And I select the following items:
      | E.14 Catering equipment maintenance |
      | G.3 Tree Surgery (Arboriculture)    |
      | H.8 Trolley service                 |
    And I click on 'Save and return'
    And I am on the 'View lot data' page
    And I should see the following services selected for lot 'a':
      | Catering equipment maintenance  |
      | Tree Surgery (Arboriculture)    |
      | Trolley service                 |

  @pipline
  Scenario: I change the services and it changes on View lot data - lot b
    Then I click on 'View lot data' for 'Terry-Greenholt'
    And I am on the 'View lot data' page
    And I change the 'services' for lot 'b'
    Then I am on the 'Lot b services' page
    And the supplier name shown is 'Terry-Greenholt'
    And I deselect all checkboxes
    And I select the following items:
      | I.9 Cleaning of communications and equipment rooms          |
      | I.10 Reactive cleaning (outside cleaning operational hours) |
    And I click on 'Save and return'
    And I am on the 'View lot data' page
    And I should see the following services selected for lot 'b':
      | Cleaning of communications and equipment rooms          |
      | Reactive cleaning (outside cleaning operational hours)  |

  Scenario: I change the services and it changes on View lot data - lot c
    Then I click on 'View lot data' for 'Cummerata, Lubowitz and Ebert'
    And I am on the 'View lot data' page
    And I change the 'services' for lot 'c'
    Then I am on the 'Lot c services' page
    And the supplier name shown is 'Cummerata, Lubowitz and Ebert'
    And I deselect all checkboxes
    And I select the following items:
      | E.20 Locksmith Services                                         |
      | F.9 Building Information Modelling and Government Soft Landings |
      | G.7 Internal planting                                           |
      | H.8 Trolley service                                             |
      | I.15 Medical and clinical cleaning                              |
      | J.9 Archiving (on-site)                                         |
      | K.4 Voice announcement system operation                         |
      | L.14 Remote CCTV / alarm monitoring                             |
      | M.7 Clinical Waste                                              |
      | N.6 Journal, magazine and newspaper supply                      |
      | O.4 Rural Estate Maintenance (REM) Services                     |
      | P.12 Future Accommodation Model (FAM)                           |
    And I click on 'Save and return'
    And I am on the 'View lot data' page
    And I should see the following services selected for lot 'c':
      | Locksmith Services                                          |
      | Building Information Modelling and Government Soft Landings |
      | Internal planting                                           |
      | Trolley service                                             |
      | Medical and clinical cleaning                               |
      | Archiving (on-site)                                         |
      | Voice announcement system operation                         |
      | Remote CCTV / alarm monitoring                              |
      | Clinical Waste                                              |
      | Journal, magazine and newspaper supply                      |
      | Rural Estate Maintenance (REM) Services                     |
      | Future Accommodation Model (FAM)                            |

  @pipline
  Scenario Outline: Breadcrumb links work from services
    Then I click on 'View lot data' for 'Yost LLC'
    And I am on the 'View lot data' page
    And I change the 'services' for lot 'c'
    Then I am on the 'Lot c services' page
    And the supplier name shown is 'Yost LLC'
    And I click on '<link_text>'
    Then I am on the '<page_title>' page

    Examples:
      | link_text     | page_title                      |
      | Home          | RM6232 administration dashboard |
      | Supplier data | Supplier data                   |
      | View lot data | View lot data                   |

  @pipline
  Scenario: I can't select core services
    Then I click on 'View lot data' for 'Skiles LLC'
    And I am on the 'View lot data' page
    And I change the 'services' for lot 'a'
    Then I am on the 'Lot a services' page
    And the supplier name shown is 'Skiles LLC'
    And I can't select any core services
