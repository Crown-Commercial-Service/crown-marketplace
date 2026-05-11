Feature: Facilities Management - Admin - Supplier lot data - 2a - View services

  Scenario: Services
    Given I sign in as an admin for the 'RM6378' framework in 'Facilities Management'
    And I click on 'Manage supplier data'
    Then I am on the 'Supplier data' page
    And I click on 'View lot data' for 'DONNELLY-KOHLER'
    Then I am on the 'Supplier lot data' page
    And the caption is 'DONNELLY-KOHLER'
    And I click on 'View services' for the lot 'Lot 2a - Hard Facilities Management'
    Then I am on the 'Lot 2a - Hard Facilities Management' page
    And the caption is 'DONNELLY-KOHLER'
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
    And the supplier should be assigned to the 'services' in 'Miscellaneous FM Services' as follows:
      | Energy and Utilities Management Bureau Services  |
      | Housing and Residential Accommodation Management |
    And the supplier should be assigned to the 'services' in 'Computer Aided Facilities Management (CAFM)' as follows:
      | Hard / Soft FM CAFM Requirements |
    And the supplier should be assigned to the 'services' in 'Helpdesk Services' as follows:
      | Helpdesk Services |
