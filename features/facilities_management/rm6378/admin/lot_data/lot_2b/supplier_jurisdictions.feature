Feature: Facilities Management - Admin - Supplier lot data - 2b - View jurisdictions

  Scenario: Services
    Given I sign in as an admin for the 'RM6378' framework in 'Facilities Management'
    And I click on 'Manage supplier data'
    Then I am on the 'Supplier data' page
    And I click on 'View lot data' for 'KEMMER AND SONS'
    Then I am on the 'Supplier lot data' page
    And the caption is 'KEMMER AND SONS'
    And I click on 'View jurisdictions' for the lot 'Lot 2b - Hard Facilities Management'
    Then I am on the 'Lot 2b - Hard Facilities Management' page
    And the caption is 'KEMMER AND SONS'
    And the supplier should be assigned to the 'jurisdictions' in 'North East (England)' as follows:
      |  |
    And the supplier should be assigned to the 'jurisdictions' in 'North West (England)' as follows:
      | Lancashire |
    And the supplier should be assigned to the 'jurisdictions' in 'Yorkshire & The Humber' as follows:
      | East Yorkshire and Northern Lincolnshire |
      | North Yorkshire                          |
      | West Yorkshire                           |
    And the supplier should be assigned to the 'jurisdictions' in 'East Midlands (England)' as follows:
      | Derbyshire and Nottinghamshire               |
      | Leicestershire, Rutland and Northamptonshire |
    And the supplier should be assigned to the 'jurisdictions' in 'West Midlands (England)' as follows:
      | Shropshire and Staffordshire |
      | West Midlands                |
    And the supplier should be assigned to the 'jurisdictions' in 'East (England)' as follows:
      | Cambridgeshire and Peterborough |
      | Suffolk                         |
    And the supplier should be assigned to the 'jurisdictions' in 'London' as follows:
      | Outer London - East and North East |
      | Outer London - West and North West |
    And the supplier should be assigned to the 'jurisdictions' in 'South East (England)' as follows:
      | Berkshire, Buckinghamshire and Oxfordshire |
    And the supplier should be assigned to the 'jurisdictions' in 'South West (England)' as follows:
      | Cornwall and Isles of Scilly |
    And the supplier should be assigned to the 'jurisdictions' in 'Wales' as follows:
      | Mid Wales                     |
      | South West Wales              |
      | Cardiff and Vale of Glamorgan |
    And the supplier should be assigned to the 'jurisdictions' in 'Scotland' as follows:
      | Falkirk                                     |
      | East Dunbartonshire and West Dunbartonshire |
      | Glasgow City                                |
      | North Ayrshire and East Ayrshire            |
      | South Lanarkshire                           |
    And the supplier should be assigned to the 'jurisdictions' in 'Northern Ireland' as follows:
      | Belfast                 |
      | Mid Ulster              |
      | Lisburn and Castlereagh |
      | Mid and East Antrim     |
    And the supplier should be assigned to the 'jurisdictions' in 'National' as follows:
      |  |
    And the supplier should be assigned to the 'jurisdictions' in 'Overseas' as follows:
      |  |
