Feature: Facilities Management - Admin - Supplier lot data - 3b - View services

  Scenario: Services
    Given I sign in as an admin for the 'RM6378' framework in 'Facilities Management'
    And I click on 'Manage supplier data'
    Then I am on the 'Supplier data' page
    And I click on 'View lot data' for 'LEANNON, HILLL AND MILLS'
    Then I am on the 'Supplier lot data' page
    And the caption is 'LEANNON, HILLL AND MILLS'
    And I click on 'View services' for the lot 'Lot 3b - Soft Facilities Management'
    Then I am on the 'Lot 3b - Soft Facilities Management' page
    And the caption is 'LEANNON, HILLL AND MILLS'
    And the supplier should be assigned to the 'services' in 'Landscaping / Horticultural Services' as follows:
      | Hard Landscaping Services      |
      | Planned Snow and Ice Clearance |
      | Tree Surgery (Arboriculture)   |
    And the supplier should be assigned to the 'services' in 'Catering Services' as follows:
      | Trolley Service |
    And the supplier should be assigned to the 'services' in 'Cleaning Services' as follows:
      | Cleaning of Integral Barrier Mats                     |
      | Deep (Periodic) Cleaning                              |
      | Reactive Cleaning (Outside Operational Working Hours) |
      | Window Cleaning (External)                            |
      | Window Cleaning (Internal)                            |
    And the supplier should be assigned to the 'services' in 'Miscellaneous FM Services' as follows:
      | Housing and Residential Accommodation Management |
      | Porterage                                        |
      | Signage                                          |
      | Space Management                                 |
    And the supplier should be assigned to the 'services' in 'Visitor Support Services' as follows:
      | Concierge Services                  |
      | Taxi Booking Service                |
      | Voice Announcement System Operation |
    And the supplier should be assigned to the 'services' in 'Waste Management' as follows:
      |  |
    And the supplier should be assigned to the 'services' in 'Computer Aided Facilities Management (CAFM)' as follows:
      | Soft FM CAFM Requirements |
    And the supplier should be assigned to the 'services' in 'Helpdesk Services' as follows:
      | Helpdesk Services |
    And the supplier should be assigned to the 'services' in 'Security Officer Services' as follows:
      | Control of Access - Vehicles                          |
      | Control of Access and Security Passes                 |
      | Key Holding                                           |
      | Management of Visitors and Passes                     |
      | Patrolling Services                                   |
      | Video Surveillance Systems (VSS) and Alarm Monitoring |
