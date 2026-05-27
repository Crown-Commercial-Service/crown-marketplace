Feature: Facilities Management - Admin - Supplier lot data - 4c - View services

  Scenario: Services
    Given I sign in as an admin for the 'RM6378' framework in 'Facilities Management'
    And I click on 'Manage supplier data'
    Then I am on the 'Supplier data' page
    And I click on 'View lot data' for 'SCHMITT, STANTON AND MAGGIO'
    Then I am on the 'Supplier lot data' page
    And the caption is 'SCHMITT, STANTON AND MAGGIO'
    And I click on 'View services' for the lot 'Lot 4c - Electronic security systems and services'
    Then I am on the 'Lot 4c - Electronic security systems and services' page
    And the caption is 'SCHMITT, STANTON AND MAGGIO'
    And the supplier should be assigned to the 'services' in 'Design, Supply, Install and Commission of Physical and Electronic Security Systems and Services' as follows:
      | Design, Supply, Install and Commission of Physical and Electronic Security Systems and Services |
    And the supplier should be assigned to the 'services' in 'Maintenance of Security Systems' as follows:
      | Planned Preventative Maintenance (PPM) Services |
      | Reactive Maintenance Services                   |
    And the supplier should be assigned to the 'services' in 'Security Operations Centre' as follows:
      | Security Operations Centre |
