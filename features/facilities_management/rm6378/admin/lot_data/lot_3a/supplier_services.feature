Feature: Facilities Management - Admin - Supplier lot data - 3a - View services

  Scenario: Services
    Given I sign in as an admin for the 'RM6378' framework in 'Facilities Management'
    And I click on 'Manage supplier data'
    Then I am on the 'Supplier data' page
    And I click on 'View lot data' for 'KEMMER GROUP'
    Then I am on the 'Supplier lot data' page
    And the caption is 'KEMMER GROUP'
    And I click on 'View services' for the lot 'Lot 3a - Soft Facilities Management'
    Then I am on the 'Lot 3a - Soft Facilities Management' page
    And the caption is 'KEMMER GROUP'
    And the supplier should be assigned to the 'services' in 'Landscaping / Horticultural Services' as follows:
      | Cut Flowers and Christmas Trees                               |
      | Hard Landscaping Services                                     |
      | Internal Planting                                             |
      | Planned Snow and Ice Clearance                                |
      | Reactive Snow and Ice Clearance                               |
      | Reservoirs, Ponds, River Walls and Water Features Maintenance |
      | Soft Landscaping Services                                     |
      | Tree Surgery (Arboriculture)                                  |
    And the supplier should be assigned to the 'services' in 'Catering Services' as follows:
      | Chilled Potable Water                 |
      | Deli / Coffee bar                     |
      | Events and Functions                  |
      | Full Service Restaurant               |
      | Hospitality and Meetings              |
      | Kiosk                                 |
      | Outside Catering                      |
      | Residential Catering Services         |
      | Trolley Service                       |
      | Vending Services (Food and Beverages) |
    And the supplier should be assigned to the 'services' in 'Cleaning Services' as follows:
      | Additional Cleaning Services                           |
      | Cleaning of External Areas                             |
      | Cleaning of Integral Barrier Mats                      |
      | Deep (Periodic) Cleaning                               |
      | Housekeeping                                           |
      | Infection Prevention and Control / Touchpoint Cleaning |
      | Pest Control Services                                  |
      | Reactive Cleaning (Outside Operational Working Hours)  |
      | Routine Cleaning                                       |
      | Standard Wash Linen and Laundry Services               |
      | Window Cleaning (External)                             |
      | Window Cleaning (Internal)                             |
    And the supplier should be assigned to the 'services' in 'Miscellaneous FM Services' as follows:
      | Additional Support Services                      |
      | Archiving (On-Site)                              |
      | Cable Management                                 |
      | Childcare Facility                               |
      | Courier Booking and Distribution Services        |
      | First Aid and Medical Service                    |
      | Furniture Management                             |
      | Housing and Residential Accommodation Management |
      | Internal Messenger Service                       |
      | Mail Services                                    |
      | Move and Space Management (Internal Moves)       |
      | Portable Washroom Solutions                      |
      | Porterage                                        |
      | Repairperson Services                            |
      | Reprographics Service                            |
      | Signage                                          |
      | Space Management                                 |
      | Sports and Leisure Service                       |
      | Stores and Goods Management Services             |
      | Transport, Driver and Vehicle Service            |
    And the supplier should be assigned to the 'services' in 'Visitor Support Services' as follows:
      | Car Park Management and Booking Service |
      | Concierge Services                      |
      | Reception Service                       |
      | Taxi Booking Service                    |
      | Voice Announcement System Operation     |
    And the supplier should be assigned to the 'services' in 'Waste Management' as follows:
      | Additional Waste Services                            |
      | General waste                                        |
      | Hazardous Waste                                      |
      | Off-Site Classified Waste Shredding Services         |
      | On-Site / Mobile Classified Waste Shredding Services |
      | Recycled Waste and Waste for Re-use                  |
      | Sanitary Waste                                       |
    And the supplier should be assigned to the 'services' in 'Computer Aided Facilities Management (CAFM)' as follows:
      | Soft FM CAFM Requirements |
    And the supplier should be assigned to the 'services' in 'Helpdesk Services' as follows:
      | Helpdesk Services |
    And the supplier should be assigned to the 'services' in 'Security Officer Services' as follows:
      | Additional Security Officer Services                  |
      | Control of Access - Vehicles                          |
      | Control of Access and Security Passes                 |
      | Key Holding                                           |
      | Management of Visitors and Passes                     |
      | Patrolling Services                                   |
      | Security Officer Services                             |
      | Video Surveillance Systems (VSS) and Alarm Monitoring |
