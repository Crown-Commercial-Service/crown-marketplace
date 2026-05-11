Feature: Facilities Management - Admin - Supplier lot data - Lot 1a - Services

  Background: Go to services
    Given I sign in as an admin for the 'RM6378' framework in 'Facilities Management'
    And I click on 'Manage supplier data'
    Then I am on the 'Supplier data' page
    And I click on 'View lot data' for 'BEATTY AND SONS'
    Then I am on the 'Supplier lot data' page
    And the caption is 'BEATTY AND SONS'
    And I click on 'View services' for the lot 'Lot 1a - Total Facilities Management'
    Then I am on the 'Lot 1a - Total Facilities Management View services' page
    And the caption is 'BEATTY AND SONS'
    And the supplier should be assigned to the 'services' in 'Maintenance Services' as follows:
      | Building Management System (BMS) Maintenance      |
      | Internal and External Building Fabric Maintenance |
      | Mechanical and Electrical Engineering Maintenance |
      | Security, Access and Intruder Systems Maintenance |
      | Specialist Maintenance Services                   |
      | Standby Power System Maintenance                  |
      | Television Cabling Maintenance                    |
      | Voice Announcement System Maintenance             |
    And the supplier should be assigned to the 'services' in 'Statutory Compliance' as follows:
      | Water Hygiene Maintenance |
    And the supplier should be assigned to the 'services' in 'Landscaping / Horticultural Services' as follows:
      | Cut Flowers and Christmas Trees |
      | Planned Snow and Ice Clearance  |
    And the supplier should be assigned to the 'services' in 'Catering Services' as follows:
      | Hospitality and Meetings      |
      | Residential Catering Services |
    And the supplier should be assigned to the 'services' in 'Cleaning Services' as follows:
      | Cleaning of Integral Barrier Mats                     |
      | Deep (Periodic) Cleaning                              |
      | Housekeeping                                          |
      | Reactive Cleaning (Outside Operational Working Hours) |
      | Window Cleaning (External)                            |
    And the supplier should be assigned to the 'services' in 'Miscellaneous FM Services' as follows:
      | Additional Support Services                      |
      | Archiving (On-Site)                              |
      | Childcare Facility                               |
      | Housing and Residential Accommodation Management |
      | Portable Washroom Solutions                      |
    And the supplier should be assigned to the 'services' in 'Visitor Support Services' as follows:
      | Reception Service |
    And the supplier should be assigned to the 'services' in 'Waste Management' as follows:
      | Additional Waste Services                            |
      | On-Site / Mobile Classified Waste Shredding Services |
      | Recycled Waste and Waste for Re-use                  |
    And the supplier should be assigned to the 'services' in 'Specialist FM Services' as follows:
      | End-User Accommodation Services |
    And the supplier should be assigned to the 'services' in 'Occupancy and Property Management Services' as follows:
      | Accommodation Compliance Services                   |
      | Accommodation Maintenance Services                  |
      | Accommodation Stores Service                        |
      | Applications and Allocations Services               |
      | Occupation Management                               |
      | Professional Property Advice and Management Service |
      | Rental Services                                     |
    And the supplier should be assigned to the 'services' in 'Computer Aided Facilities Management (CAFM)' as follows:
      |  |
    And the supplier should be assigned to the 'services' in 'Helpdesk Services' as follows:
      | Helpdesk Services |
    And the supplier should be assigned to the 'services' in 'Security Officer Services' as follows:
      | Additional Security Officer Services |
      | Control of Access - Vehicles         |
      | Security Officer Services            |
    Given I click on 'Change (Services the supplier can offer)'
    Then I am on the 'Edit service selection' page
    And the caption is 'BEATTY AND SONS'

  Scenario: Update services
    When I select the following items:
      | Audio Visual (AV) Equipment Maintenance               |
      | Video Surveillance Systems (VSS) and Alarm Monitoring |
    When I deselect the following items:
      | Internal and External Building Fabric Maintenance |
      | Additional Waste Services                         |
      | Rental Services                                   |
    Then I click on 'Save and return'
    Then I am on the 'Lot 1a - Total Facilities Management View services' page
    And the caption is 'BEATTY AND SONS'
    And the supplier should be assigned to the 'services' in 'Maintenance Services' as follows:
      | Audio Visual (AV) Equipment Maintenance           |
      | Building Management System (BMS) Maintenance      |
      | Mechanical and Electrical Engineering Maintenance |
      | Security, Access and Intruder Systems Maintenance |
      | Specialist Maintenance Services                   |
      | Standby Power System Maintenance                  |
      | Television Cabling Maintenance                    |
      | Voice Announcement System Maintenance             |
    And the supplier should be assigned to the 'services' in 'Statutory Compliance' as follows:
      | Water Hygiene Maintenance |
    And the supplier should be assigned to the 'services' in 'Landscaping / Horticultural Services' as follows:
      | Cut Flowers and Christmas Trees |
      | Planned Snow and Ice Clearance  |
    And the supplier should be assigned to the 'services' in 'Catering Services' as follows:
      | Hospitality and Meetings      |
      | Residential Catering Services |
    And the supplier should be assigned to the 'services' in 'Cleaning Services' as follows:
      | Cleaning of Integral Barrier Mats                     |
      | Deep (Periodic) Cleaning                              |
      | Housekeeping                                          |
      | Reactive Cleaning (Outside Operational Working Hours) |
      | Window Cleaning (External)                            |
    And the supplier should be assigned to the 'services' in 'Miscellaneous FM Services' as follows:
      | Additional Support Services                      |
      | Archiving (On-Site)                              |
      | Childcare Facility                               |
      | Housing and Residential Accommodation Management |
      | Portable Washroom Solutions                      |
    And the supplier should be assigned to the 'services' in 'Visitor Support Services' as follows:
      | Reception Service |
    And the supplier should be assigned to the 'services' in 'Waste Management' as follows:
      | On-Site / Mobile Classified Waste Shredding Services |
      | Recycled Waste and Waste for Re-use                  |
    And the supplier should be assigned to the 'services' in 'Specialist FM Services' as follows:
      | End-User Accommodation Services |
    And the supplier should be assigned to the 'services' in 'Occupancy and Property Management Services' as follows:
      | Accommodation Compliance Services                   |
      | Accommodation Maintenance Services                  |
      | Accommodation Stores Service                        |
      | Applications and Allocations Services               |
      | Occupation Management                               |
      | Professional Property Advice and Management Service |
    And the supplier should be assigned to the 'services' in 'Computer Aided Facilities Management (CAFM)' as follows:
      |  |
    And the supplier should be assigned to the 'services' in 'Helpdesk Services' as follows:
      | Helpdesk Services |
    And the supplier should be assigned to the 'services' in 'Security Officer Services' as follows:
      | Additional Security Officer Services                  |
      | Control of Access - Vehicles                          |
      | Security Officer Services                             |
      | Video Surveillance Systems (VSS) and Alarm Monitoring |

  Scenario: Remove all services
    When I deselect the following items:
      | Building Management System (BMS) Maintenance          |
      | Internal and External Building Fabric Maintenance     |
      | Mechanical and Electrical Engineering Maintenance     |
      | Security, Access and Intruder Systems Maintenance     |
      | Specialist Maintenance Services                       |
      | Standby Power System Maintenance                      |
      | Television Cabling Maintenance                        |
      | Voice Announcement System Maintenance                 |
      | Water Hygiene Maintenance                             |
      | Cut Flowers and Christmas Trees                       |
      | Planned Snow and Ice Clearance                        |
      | Hospitality and Meetings                              |
      | Residential Catering Services                         |
      | Cleaning of Integral Barrier Mats                     |
      | Deep (Periodic) Cleaning                              |
      | Housekeeping                                          |
      | Reactive Cleaning (Outside Operational Working Hours) |
      | Window Cleaning (External)                            |
      | Additional Support Services                           |
      | Archiving (On-Site)                                   |
      | Childcare Facility                                    |
      | Housing and Residential Accommodation Management      |
      | Portable Washroom Solutions                           |
      | Reception Service                                     |
      | Additional Waste Services                             |
      | On-Site / Mobile Classified Waste Shredding Services  |
      | Recycled Waste and Waste for Re-use                   |
      | End-User Accommodation Services                       |
      | Accommodation Compliance Services                     |
      | Accommodation Maintenance Services                    |
      | Accommodation Stores Service                          |
      | Applications and Allocations Services                 |
      | Occupation Management                                 |
      | Professional Property Advice and Management Service   |
      | Rental Services                                       |
      | Helpdesk Services                                     |
      | Additional Security Officer Services                  |
      | Control of Access - Vehicles                          |
      | Security Officer Services                             |
    Then I click on 'Save and return'
    Then I am on the 'Lot 1a - Total Facilities Management View services' page
    And the caption is 'BEATTY AND SONS'
    And the supplier should not be assigned any 'services' with the following message:
      | The supplier does not offer any services in this lot |
