Feature: Facilities Management - Admin - Supplier lot data - 2b - View services

  Scenario: Services
    Given I sign in as an admin for the 'RM6378' framework in 'Facilities Management'
    And I click on 'Manage supplier data'
    Then I am on the 'Supplier data' page
    And I click on 'View lot data' for 'KEMMER AND SONS'
    Then I am on the 'Supplier lot data' page
    And the caption is 'KEMMER AND SONS'
    And I click on 'View services' for the lot 'Lot 2b - Hard Facilities Management'
    Then I am on the 'Lot 2b - Hard Facilities Management' page
    And the caption is 'KEMMER AND SONS'
    And the supplier should be assigned to the 'services' in 'Maintenance Services' as follows:
      | Audio Visual (AV) Equipment Maintenance              |
      | Automated Barrier Control System Maintenance         |
      | Building Management System (BMS) Maintenance         |
      | Environmental Cleaning Service                       |
      | Fire Detection and Firefighting Systems Maintenance  |
      | Hoists and Conveyance Systems Maintenance            |
      | Lifts Maintenance                                    |
      | Locksmith Services                                   |
      | Mechanical and Electrical Engineering Maintenance    |
      | Office Machinery Servicing and Maintenance           |
      | Planned / Group Re-Lamping Service                   |
      | Reactive Maintenance Service                         |
      | Television Cabling Maintenance                       |
      | Ventilation and Air Conditioning Systems Maintenance |
      | Voice Announcement System Maintenance                |
    And the supplier should be assigned to the 'services' in 'Statutory Compliance' as follows:
      | Building Information Modelling (BIM) and Government Soft Landings (GSL) |
      | Condition Surveys                                                       |
      | Display Energy Certificates (DECs)                                      |
      | Electrical Testing                                                      |
      | Energy Performance Certificates (EPCs)                                  |
      | Fire Risk Assessments                                                   |
      | Miscellaneous Surveys , Audits and Testing Services                     |
      | Permit to Work (PtW)                                                    |
      | Radon Gas Management Services                                           |
      | Water Hygiene Maintenance                                               |
    And the supplier should be assigned to the 'services' in 'Miscellaneous FM Services' as follows:
      | Energy and Utilities Management Bureau Services |
    And the supplier should be assigned to the 'services' in 'Computer Aided Facilities Management (CAFM)' as follows:
      | Hard / Soft FM CAFM Requirements |
    And the supplier should be assigned to the 'services' in 'Helpdesk Services' as follows:
      | Helpdesk Services |
