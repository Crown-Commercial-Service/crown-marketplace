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
      | supplier_name           | lot | title             |
      | Haag LLC                | 3a  | Lot 3a services   |
      | Glover, Koepp and Rohan | 2b  | Lot 2b services   |
      | Skiles-Reynolds         | 1c  | Lot 1c services   |

  Scenario: I change the services and it changes on View lot data - lot 1a
    Then I click on 'View lot data' for 'Will and Sons'
    And I am on the 'View lot data' page
    And I change the 'services' for lot '1a'
    Then I am on the 'Lot 1a services' page
    And the supplier name shown is 'Will and Sons'
    And I deselect all checkboxes
    And I select the following items:
      | E.14 Catering equipment maintenance |
      | G.3 Tree Surgery (Arboriculture)    |
      | H.8 Trolley service                 |
    And I click on 'Save and return'
    And I am on the 'View lot data' page
    And I should see the following services selected for lot '1a':
      | Catering equipment maintenance  |
      | Tree Surgery (Arboriculture)    |
      | Trolley service                 |

  @pipline
  Scenario: I change the services and it changes on View lot data - lot 2b
    Then I click on 'View lot data' for 'Gleichner, Wintheiser and Wilderman'
    And I am on the 'View lot data' page
    And I change the 'services' for lot '2b'
    Then I am on the 'Lot 2b services' page
    And the supplier name shown is 'Gleichner, Wintheiser and Wilderman'
    And I deselect all checkboxes
    And I select the following items:
      | F.9 Building Information Modelling and Government Soft Landings |
      | N.11 Energy and utilities management bureau Services            |
    And I click on 'Save and return'
    And I am on the 'View lot data' page
    And I should see the following services selected for lot '2b':
      | Building Information Modelling and Government Soft Landings |
      | Energy and utilities management bureau Services             |

  Scenario: I change the services and it changes on View lot data - lot 3c
    Then I click on 'View lot data' for 'Lehner, Bosco and Kuphal'
    And I am on the 'View lot data' page
    And I change the 'services' for lot '3c'
    Then I am on the 'Lot 3c services' page
    And the supplier name shown is 'Lehner, Bosco and Kuphal'
    And I deselect all checkboxes
    And I select the following items:
      | G.7 Internal planting                       |
      | H.8 Trolley service                         |
      | I.15 Medical and clinical cleaning          |
      | J.9 Archiving (on-site)                     |
      | K.4 Voice announcement system operation     |
      | L.14 Remote CCTV / alarm monitoring         |
      | M.7 Clinical Waste                          |
      | N.6 Journal, magazine and newspaper supply  |
    And I click on 'Save and return'
    And I am on the 'View lot data' page
    And I should see the following services selected for lot '3c':
      | Internal planting                       |
      | Trolley service                         |
      | Medical and clinical cleaning           |
      | Archiving (on-site)                     |
      | Voice announcement system operation     |
      | Remote CCTV / alarm monitoring          |
      | Clinical Waste                          |
      | Journal, magazine and newspaper supply  |

  @pipline
  Scenario Outline: Breadcrumb links work from services
    Then I click on 'View lot data' for 'Beer, Renner and Davis'
    And I am on the 'View lot data' page
    And I change the 'services' for lot '1c'
    Then I am on the 'Lot 1c services' page
    And the supplier name shown is 'Beer, Renner and Davis'
    And I click on '<link_text>'
    Then I am on the '<page_title>' page

    Examples:
      | link_text     | page_title                      |
      | Home          | RM6232 administration dashboard |
      | Supplier data | Supplier data                   |
      | View lot data | View lot data                   |

  @pipline
  Scenario: I can't select core services
    Then I click on 'View lot data' for 'Schaden Inc'
    And I am on the 'View lot data' page
    And I change the 'services' for lot '1a'
    Then I am on the 'Lot 1a services' page
    And the supplier name shown is 'Schaden Inc'
    And I can't select any core services
