Feature: Facilities Management - Admin - Supplier lot data - 1c - View services

  Scenario: Services
    Given I sign in as an admin for the 'RM6378' framework in 'Facilities Management'
    And I click on 'Manage supplier data'
    Then I am on the 'Supplier data' page
    And I click on 'View lot data' for 'CRONIN-AUFDERHAR'
    Then I am on the 'Supplier lot data' page
    And the caption is 'CRONIN-AUFDERHAR'
    And I click on 'View services' for the lot 'Lot 1c - Total Facilities Management'
    Then I am on the 'Lot 1c - Total Facilities Management' page
    And the caption is 'CRONIN-AUFDERHAR'
    And the supplier should be assigned to the 'services' in 'Maintenance Services' as follows:
      | High Voltage (HV) and Switchgear Maintenance |
      | Locksmith Services                           |
      | Planned / Group Re-Lamping Service           |
      | Reactive Maintenance Service                 |
      | Specialist Maintenance Services              |
      | Television Cabling Maintenance               |
      | Voice Announcement System Maintenance        |
    And the supplier should be assigned to the 'services' in 'Statutory Compliance' as follows:
      | Electrical Testing                                  |
      | Miscellaneous Surveys , Audits and Testing Services |
      | Statutory Inspections                               |
      | Water Hygiene Maintenance                           |
    And the supplier should be assigned to the 'services' in 'Landscaping / Horticultural Services' as follows:
      | Cut Flowers and Christmas Trees                               |
      | Internal Planting                                             |
      | Reservoirs, Ponds, River Walls and Water Features Maintenance |
      | Tree Surgery (Arboriculture)                                  |
    And the supplier should be assigned to the 'services' in 'Catering Services' as follows:
      | Deli / Coffee bar                     |
      | Events and Functions                  |
      | Hospitality and Meetings              |
      | Kiosk                                 |
      | Vending Services (Food and Beverages) |
    And the supplier should be assigned to the 'services' in 'Cleaning Services' as follows:
      | Deep (Periodic) Cleaning                 |
      | Housekeeping                             |
      | Pest Control Services                    |
      | Standard Wash Linen and Laundry Services |
    And the supplier should be assigned to the 'services' in 'Miscellaneous FM Services' as follows:
      | Archiving (On-Site)                              |
      | Cable Management                                 |
      | Courier Booking and Distribution Services        |
      | Energy and Utilities Management Bureau Services  |
      | Furniture Management                             |
      | Housing and Residential Accommodation Management |
      | Internal Messenger Service                       |
      | Move and Space Management (Internal Moves)       |
      | Repairperson Services                            |
      | Reprographics Service                            |
      | Stores and Goods Management Services             |
    And the supplier should be assigned to the 'services' in 'Visitor Support Services' as follows:
      | Reception Service |
    And the supplier should be assigned to the 'services' in 'Waste Management' as follows:
      | Additional Waste Services                            |
      | General waste                                        |
      | Hazardous Waste                                      |
      | Off-Site Classified Waste Shredding Services         |
      | On-Site / Mobile Classified Waste Shredding Services |
      | Recycled Waste and Waste for Re-use                  |
      | Sanitary Waste                                       |
    And the supplier should be assigned to the 'services' in 'Specialist FM Services' as follows:
      | Management and Control of Ranges and Training Areas (MCRT) and specialist FM services (including the Operation of a Bidding and Allocation Management (BAMS) system) |
      | Training Areas and Ranges Operation and Management (TAROM) Services and the provision of a service for Targets deployed overseas                                     |
    And the supplier should be assigned to the 'services' in 'Occupancy and Property Management Services' as follows:
      | Accommodation Compliance Services  |
      | Accommodation Maintenance Services |
      | Accommodation Stores Service       |
      | Customer Service Centre            |
      | Occupancy Management               |
      | Third Party Claims                 |
    And the supplier should be assigned to the 'services' in 'Computer Aided Facilities Management (CAFM)' as follows:
      |  |
    And the supplier should be assigned to the 'services' in 'Helpdesk Services' as follows:
      | Helpdesk Services |
    And the supplier should be assigned to the 'services' in 'Security Officer Services' as follows:
      | Control of Access and Security Passes                 |
      | Key Holding                                           |
      | Management of Visitors and Passes                     |
      | Patrolling Services                                   |
      | Video Surveillance Systems (VSS) and Alarm Monitoring |
