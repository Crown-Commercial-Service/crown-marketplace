Feature: Facilities Management - Admin - Supplier lot data - 1b - View services

  Scenario: Services
    Given I sign in as an admin for the 'RM6378' framework in 'Facilities Management'
    And I click on 'Manage supplier data'
    Then I am on the 'Supplier data' page
    And I click on 'View lot data' for 'BEIER INC'
    Then I am on the 'Supplier lot data' page
    And the caption is 'BEIER INC'
    And I click on 'View services' for the lot 'Lot 1b - Total Facilities Management'
    Then I am on the 'Lot 1b - Total Facilities Management' page
    And the caption is 'BEIER INC'
    And the supplier should be assigned to the 'services' in 'Statutory Compliance' as follows:
      | Asbestos Management                                                     |
      | Building Information Modelling (BIM) and Government Soft Landings (GSL) |
      | Condition Surveys                                                       |
      | Display Energy Certificates (DECs)                                      |
      | Electrical Testing                                                      |
      | Energy Performance Certificates (EPCs)                                  |
      | Fire Risk Assessments                                                   |
      | Miscellaneous Surveys , Audits and Testing Services                     |
      | Permit to Work (PtW)                                                    |
      | Portable Appliance Testing (PAT)                                        |
      | Radon Gas Management Services                                           |
      | Statutory Inspections                                                   |
      | Water Hygiene Maintenance                                               |
    And the supplier should be assigned to the 'services' in 'Maintenance Services' as follows:
      | Audio Visual (AV) Equipment Maintenance              |
      | Automated Barrier Control System Maintenance         |
      | Building Management System (BMS) Maintenance         |
      | Catering Equipment Maintenance                       |
      | Environmental Cleaning Service                       |
      | Fire Detection and Firefighting Systems Maintenance  |
      | High Voltage (HV) and Switchgear Maintenance         |
      | Hoists and Conveyance Systems Maintenance            |
      | Internal and External Building Fabric Maintenance    |
      | Lifts Maintenance                                    |
      | Locksmith Services                                   |
      | Mail Room Equipment Maintenance                      |
      | Mechanical and Electrical Engineering Maintenance    |
      | Office Machinery Servicing and Maintenance           |
      | Planned / Group Re-Lamping Service                   |
      | Reactive Maintenance Service                         |
      | Security, Access and Intruder Systems Maintenance    |
      | Specialist Maintenance Services                      |
      | Standby Power System Maintenance                     |
      | Television Cabling Maintenance                       |
      | Ventilation and Air Conditioning Systems Maintenance |
      | Voice Announcement System Maintenance                |
    And the supplier should be assigned to the 'services' in 'Miscellaneous FM Services' as follows:
      | Additional Support Services                      |
      | Archiving (On-Site)                              |
      | Cable Management                                 |
      | Childcare Facility                               |
      | Courier Booking and Distribution Services        |
      | Energy and Utilities Management Bureau Services  |
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
    And the supplier should be assigned to the 'services' in 'Specialist FM Services' as follows:
      | End-User Accommodation Services                                                                                                                                      |
      | Land Management Service (LMS)                                                                                                                                        |
      | Management and Control of Ranges and Training Areas (MCRT) and specialist FM services (including the Operation of a Bidding and Allocation Management (BAMS) system) |
      | Rural Estate Maintenance (REM) Services                                                                                                                              |
      | Training Areas and Ranges Operation and Management (TAROM) Services and the provision of a service for Targets deployed overseas                                     |
    And the supplier should be assigned to the 'services' in 'Occupancy and Property Management Services' as follows:
      | Accommodation Compliance Services                   |
      | Accommodation Maintenance Services                  |
      | Accommodation Stores Service                        |
      | Applications and Allocations Services               |
      | Customer Service Centre                             |
      | Emergency Accommodation                             |
      | Housing Stock Management                            |
      | Occupancy Management                                |
      | Occupation Management                               |
      | Professional Property Advice and Management Service |
      | Property Maintenance Support Desk Services          |
      | Rental Services                                     |
      | Special Need or Disability Adaptions                |
      | Third Party Claims                                  |
    And the supplier should be assigned to the 'services' in 'Computer Aided Facilities Management (CAFM)' as follows:
      | Hard / Soft FM CAFM Requirements |
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
