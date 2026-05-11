Feature: Facilities Management - Admin - Supplier lot data - 4d - View jurisdictions

  Scenario: Services
    Given I sign in as an admin for the 'RM6378' framework in 'Facilities Management'
    And I click on 'Manage supplier data'
    Then I am on the 'Supplier data' page
    And I click on 'View lot data' for 'TOWNE-BOGISICH'
    Then I am on the 'Supplier lot data' page
    And the caption is 'TOWNE-BOGISICH'
    And I click on 'View jurisdictions' for the lot 'Lot 4d - Security advisory and assessment services'
    Then I am on the 'Lot 4d - Security advisory and assessment services' page
    And the caption is 'TOWNE-BOGISICH'
    And the supplier should be assigned to the 'jurisdictions' in 'North East (England)' as follows:
      | Tees Valley |
    And the supplier should be assigned to the 'jurisdictions' in 'North West (England)' as follows:
      | Greater Manchester |
      | Lancashire         |
      | Cheshire           |
      | Merseyside         |
    And the supplier should be assigned to the 'jurisdictions' in 'Yorkshire & The Humber' as follows:
      | West Yorkshire |
    And the supplier should be assigned to the 'jurisdictions' in 'East Midlands (England)' as follows:
      |  |
    And the supplier should be assigned to the 'jurisdictions' in 'West Midlands (England)' as follows:
      | Herefordshire, Worcestershire and Warwickshire |
      | West Midlands                                  |
    And the supplier should be assigned to the 'jurisdictions' in 'East (England)' as follows:
      | Suffolk |
    And the supplier should be assigned to the 'jurisdictions' in 'London' as follows:
      | Inner London - East                |
      | Outer London - East and North East |
      | Outer London - South               |
      | Outer London - West and North West |
    And the supplier should be assigned to the 'jurisdictions' in 'South East (England)' as follows:
      | Berkshire, Buckinghamshire and Oxfordshire |
      | Hampshire and Isle of Wight                |
    And the supplier should be assigned to the 'jurisdictions' in 'South West (England)' as follows:
      | Devon                         |
      | West of England               |
      | Gloucestershire and Wiltshire |
    And the supplier should be assigned to the 'jurisdictions' in 'Wales' as follows:
      | Conwy and Denbighshire    |
      | Flintshire and Wrexham    |
      | Swansea                   |
      | Gwent Valleys             |
      | Monmouthshire and Newport |
    And the supplier should be assigned to the 'jurisdictions' in 'Scotland' as follows:
      | Clackmannanshire and Fife                       |
      | Perth and Kinross, and Stirling                 |
      | Falkirk                                         |
      | West Lothian                                    |
      | Highlands and Islands                           |
      | Inverclyde, East Renfrewshire, and Renfrewshire |
      | North Lanarkshire                               |
      | Scottish Borders                                |
      | Dumfries and Galloway                           |
      | South Lanarkshire                               |
    And the supplier should be assigned to the 'jurisdictions' in 'Northern Ireland' as follows:
      | Belfast    |
      | Mid Ulster |
    And the supplier should be assigned to the 'jurisdictions' in 'National' as follows:
      | National coverage (all of the above) |
    And the supplier should be assigned to the 'jurisdictions' in 'Overseas' as follows:
      |  |
