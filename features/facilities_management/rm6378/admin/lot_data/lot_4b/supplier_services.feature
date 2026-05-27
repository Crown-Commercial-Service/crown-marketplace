Feature: Facilities Management - Admin - Supplier lot data - 4b - View services

  Scenario: Services
    Given I sign in as an admin for the 'RM6378' framework in 'Facilities Management'
    And I click on 'Manage supplier data'
    Then I am on the 'Supplier data' page
    And I click on 'View lot data' for 'PFANNERSTILL-DICKENS'
    Then I am on the 'Supplier lot data' page
    And the caption is 'PFANNERSTILL-DICKENS'
    And I click on 'View services' for the lot 'Lot 4b - Security Officer Services'
    Then I am on the 'Lot 4b - Security Officer Services' page
    And the caption is 'PFANNERSTILL-DICKENS'
    And the supplier should be assigned to the 'services' in 'Security Officer Services' as follows:
      | Additional Security Officer Services                  |
      | Control of Access - Vehicles                          |
      | Control of Access and Security Passes                 |
      | Key Holding                                           |
      | Management of Visitors and Passes                     |
      | Patrolling Services                                   |
      | Security Officer Services                             |
      | Video Surveillance Systems (VSS) and Alarm Monitoring |
