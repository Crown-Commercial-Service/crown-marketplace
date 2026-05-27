Feature: Facilities Management - Admin - Supplier lot data - 4b - View jurisdictions

  Scenario: Services
    Given I sign in as an admin for the 'RM6378' framework in 'Facilities Management'
    And I click on 'Manage supplier data'
    Then I am on the 'Supplier data' page
    And I click on 'View lot data' for 'PFANNERSTILL-DICKENS'
    Then I am on the 'Supplier lot data' page
    And the caption is 'PFANNERSTILL-DICKENS'
    And I click on 'View jurisdictions' for the lot 'Lot 4b - Security Officer Services'
    Then I am on the 'Lot 4b - Security Officer Services' page
    And the caption is 'PFANNERSTILL-DICKENS'
    And the supplier should be assigned to the 'jurisdictions' in 'North East (England)' as follows:
      | Tees Valley                            |
      | Northumberland, Durham and Tyne & Wear |
    And the supplier should be assigned to the 'jurisdictions' in 'North West (England)' as follows:
      | Cumbria            |
      | Greater Manchester |
      | Lancashire         |
      | Cheshire           |
      | Merseyside         |
    And the supplier should be assigned to the 'jurisdictions' in 'Yorkshire & The Humber' as follows:
      | East Yorkshire and Northern Lincolnshire |
      | North Yorkshire                          |
      | South Yorkshire                          |
      | West Yorkshire                           |
    And the supplier should be assigned to the 'jurisdictions' in 'East Midlands (England)' as follows:
      | Derbyshire and Nottinghamshire               |
      | Leicestershire, Rutland and Northamptonshire |
      | Lincolnshire                                 |
    And the supplier should be assigned to the 'jurisdictions' in 'West Midlands (England)' as follows:
      | Herefordshire, Worcestershire and Warwickshire |
      | Shropshire and Staffordshire                   |
      | West Midlands                                  |
    And the supplier should be assigned to the 'jurisdictions' in 'East (England)' as follows:
      | Bedfordshire and Hertfordshire  |
      | Essex                           |
      | Cambridgeshire and Peterborough |
      | Norfolk                         |
      | Suffolk                         |
    And the supplier should be assigned to the 'jurisdictions' in 'London' as follows:
      | Inner London - West                |
      | Inner London - East                |
      | Outer London - East and North East |
      | Outer London - South               |
      | Outer London - West and North West |
    And the supplier should be assigned to the 'jurisdictions' in 'South East (England)' as follows:
      | Berkshire, Buckinghamshire and Oxfordshire |
      | Surrey, East and West Sussex               |
      | Hampshire and Isle of Wight                |
      | Kent                                       |
    And the supplier should be assigned to the 'jurisdictions' in 'South West (England)' as follows:
      | Cornwall and Isles of Scilly        |
      | Devon                               |
      | West of England                     |
      | North Somerset, Somerset and Dorset |
      | Gloucestershire and Wiltshire       |
    And the supplier should be assigned to the 'jurisdictions' in 'Wales' as follows:
      | Isle of Anglesey              |
      | Gwynedd                       |
      | Conwy and Denbighshire        |
      | Flintshire and Wrexham        |
      | Mid Wales                     |
      | South West Wales              |
      | Swansea                       |
      | Neath Port Talbot             |
      | Central Valleys and Bridgend  |
      | Cardiff and Vale of Glamorgan |
      | Gwent Valleys                 |
      | Monmouthshire and Newport     |
    And the supplier should be assigned to the 'jurisdictions' in 'Scotland' as follows:
      | Clackmannanshire and Fife                       |
      | Perth and Kinross, and Stirling                 |
      | Angus and Dundee City                           |
      | East Lothian and Midlothian                     |
      | Falkirk                                         |
      | City of Edinburgh                               |
      | West Lothian                                    |
      | Highlands and Islands                           |
      | East Dunbartonshire and West Dunbartonshire     |
      | Glasgow City                                    |
      | Inverclyde, East Renfrewshire, and Renfrewshire |
      | North Lanarkshire                               |
      | Aberdeen City and Aberdeenshire                 |
      | Scottish Borders                                |
      | Dumfries and Galloway                           |
      | North Ayrshire and East Ayrshire                |
      | South Ayrshire                                  |
      | South Lanarkshire                               |
    And the supplier should be assigned to the 'jurisdictions' in 'Northern Ireland' as follows:
      | Belfast                              |
      | Armagh City, Banbridge and Craigavon |
      | Newry, Mourne and Down               |
      | Ards and North Down                  |
      | Derry City and Strabane              |
      | Mid Ulster                           |
      | Causeway Coast and Glens             |
      | Antrim and Newtownabbey              |
      | Lisburn and Castlereagh              |
      | Mid and East Antrim                  |
      | Fermanagh and Omagh                  |
    And the supplier should be assigned to the 'jurisdictions' in 'National' as follows:
      | National coverage (all of the above) |
    And the supplier should be assigned to the 'jurisdictions' in 'Overseas' as follows:
      | International coverage |
