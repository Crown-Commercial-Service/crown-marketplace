Feature: Facilities Management - Admin - Supplier lot data - 4a - View services

  Scenario: Services
    Given I sign in as an admin for the 'RM6378' framework in 'Facilities Management'
    And I click on 'Manage supplier data'
    Then I am on the 'Supplier data' page
    And I click on 'View lot data' for 'MAYER INC'
    Then I am on the 'Supplier lot data' page
    And the caption is 'MAYER INC'
    And I click on 'View services' for the lot 'Lot 4a - Total Security Services'
    Then I am on the 'Lot 4a - Total Security Services' page
    And the caption is 'MAYER INC'
    And the supplier should be assigned to the 'services' in 'Security Officer Services' as follows:
      | Additional Security Officer Services                  |
      | Control of Access - Vehicles                          |
      | Control of Access and Security Passes                 |
      | Key Holding                                           |
      | Management of Visitors and Passes                     |
      | Patrolling Services                                   |
      | Security Officer Services                             |
      | Video Surveillance Systems (VSS) and Alarm Monitoring |
    And the supplier should be assigned to the 'services' in 'Design, Supply, Install and Commission of Physical and Electronic Security Systems and Services' as follows:
      | Design, Supply, Install and Commission of Physical and Electronic Security Systems and Services |
    And the supplier should be assigned to the 'services' in 'Maintenance of Security Systems' as follows:
      | Planned Preventative Maintenance (PPM) Services |
      | Reactive Maintenance Services                   |
    And the supplier should be assigned to the 'services' in 'Security Operations Centre' as follows:
      | Security Operations Centre |
    And the supplier should be assigned to the 'services' in 'Security Advisory Services' as follows:
      | Security Advisory Services |
    And the supplier should be assigned to the 'services' in 'Security and Risk Assessments' as follows:
      | Risk Assessments     |
      | Security Assessments |
    And the supplier should be assigned to the 'services' in 'Security Awareness / Training' as follows:
      | Security Awareness / Training |
