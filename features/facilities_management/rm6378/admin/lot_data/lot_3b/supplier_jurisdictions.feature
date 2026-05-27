Feature: Facilities Management - Admin - Supplier lot data - 3b - View jurisdictions

  Scenario: Services
    Given I sign in as an admin for the 'RM6378' framework in 'Facilities Management'
    And I click on 'Manage supplier data'
    Then I am on the 'Supplier data' page
    And I click on 'View lot data' for 'LEANNON, HILLL AND MILLS'
    Then I am on the 'Supplier lot data' page
    And the caption is 'LEANNON, HILLL AND MILLS'
    And I click on 'View jurisdictions' for the lot 'Lot 3b - Soft Facilities Management'
    Then I am on the 'Lot 3b - Soft Facilities Management' page
    And the caption is 'LEANNON, HILLL AND MILLS'
    And the supplier should be assigned to the 'jurisdictions' in 'North East (England)' as follows:
      | Tees Valley                            |
      | Northumberland, Durham and Tyne & Wear |
    And the supplier should be assigned to the 'jurisdictions' in 'North West (England)' as follows:
      | Cumbria            |
      | Greater Manchester |
      | Merseyside         |
    And the supplier should be assigned to the 'jurisdictions' in 'Yorkshire & The Humber' as follows:
      | East Yorkshire and Northern Lincolnshire |
      | North Yorkshire                          |
      | West Yorkshire                           |
    And the supplier should be assigned to the 'jurisdictions' in 'East Midlands (England)' as follows:
      | Derbyshire and Nottinghamshire |
    And the supplier should be assigned to the 'jurisdictions' in 'West Midlands (England)' as follows:
      | West Midlands |
    And the supplier should be assigned to the 'jurisdictions' in 'East (England)' as follows:
      | Bedfordshire and Hertfordshire |
      | Essex                          |
    And the supplier should be assigned to the 'jurisdictions' in 'London' as follows:
      | Inner London - East  |
      | Outer London - South |
    And the supplier should be assigned to the 'jurisdictions' in 'South East (England)' as follows:
      | Berkshire, Buckinghamshire and Oxfordshire |
      | Surrey, East and West Sussex               |
      | Hampshire and Isle of Wight                |
    And the supplier should be assigned to the 'jurisdictions' in 'South West (England)' as follows:
      | Cornwall and Isles of Scilly |
      | West of England              |
    And the supplier should be assigned to the 'jurisdictions' in 'Wales' as follows:
      | Gwynedd                       |
      | Conwy and Denbighshire        |
      | Flintshire and Wrexham        |
      | South West Wales              |
      | Neath Port Talbot             |
      | Central Valleys and Bridgend  |
      | Cardiff and Vale of Glamorgan |
    And the supplier should be assigned to the 'jurisdictions' in 'Scotland' as follows:
      | Clackmannanshire and Fife                       |
      | Perth and Kinross, and Stirling                 |
      | Angus and Dundee City                           |
      | Falkirk                                         |
      | City of Edinburgh                               |
      | Highlands and Islands                           |
      | East Dunbartonshire and West Dunbartonshire     |
      | Glasgow City                                    |
      | Inverclyde, East Renfrewshire, and Renfrewshire |
      | North Lanarkshire                               |
      | Aberdeen City and Aberdeenshire                 |
      | Dumfries and Galloway                           |
      | South Lanarkshire                               |
    And the supplier should be assigned to the 'jurisdictions' in 'Northern Ireland' as follows:
      | Belfast                 |
      | Newry, Mourne and Down  |
      | Derry City and Strabane |
      | Antrim and Newtownabbey |
      | Mid and East Antrim     |
      | Fermanagh and Omagh     |
    And the supplier should be assigned to the 'jurisdictions' in 'National' as follows:
      |  |
    And the supplier should be assigned to the 'jurisdictions' in 'Overseas' as follows:
      | International coverage |
