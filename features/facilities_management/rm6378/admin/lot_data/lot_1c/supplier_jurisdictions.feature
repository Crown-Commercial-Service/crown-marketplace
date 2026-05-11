Feature: Facilities Management - Admin - Supplier lot data - 1c - View jurisdictions

  Scenario: Services
    Given I sign in as an admin for the 'RM6378' framework in 'Facilities Management'
    And I click on 'Manage supplier data'
    Then I am on the 'Supplier data' page
    And I click on 'View lot data' for 'CRONIN-AUFDERHAR'
    Then I am on the 'Supplier lot data' page
    And the caption is 'CRONIN-AUFDERHAR'
    And I click on 'View jurisdictions' for the lot 'Lot 1c - Total Facilities Management'
    Then I am on the 'Lot 1c - Total Facilities Management' page
    And the caption is 'CRONIN-AUFDERHAR'
    And the supplier should be assigned to the 'jurisdictions' in 'North East (England)' as follows:
      |  |
    And the supplier should be assigned to the 'jurisdictions' in 'North West (England)' as follows:
      | Lancashire |
      | Merseyside |
    And the supplier should be assigned to the 'jurisdictions' in 'Yorkshire & The Humber' as follows:
      | East Yorkshire and Northern Lincolnshire |
      | North Yorkshire                          |
      | West Yorkshire                           |
    And the supplier should be assigned to the 'jurisdictions' in 'East Midlands (England)' as follows:
      | Derbyshire and Nottinghamshire               |
      | Leicestershire, Rutland and Northamptonshire |
      | Lincolnshire                                 |
    And the supplier should be assigned to the 'jurisdictions' in 'West Midlands (England)' as follows:
      | West Midlands |
    And the supplier should be assigned to the 'jurisdictions' in 'East (England)' as follows:
      | Bedfordshire and Hertfordshire  |
      | Essex                           |
      | Cambridgeshire and Peterborough |
      | Suffolk                         |
    And the supplier should be assigned to the 'jurisdictions' in 'London' as follows:
      | Outer London - East and North East |
      | Outer London - South               |
    And the supplier should be assigned to the 'jurisdictions' in 'South East (England)' as follows:
      | Surrey, East and West Sussex |
      | Kent                         |
    And the supplier should be assigned to the 'jurisdictions' in 'South West (England)' as follows:
      | West of England               |
      | Gloucestershire and Wiltshire |
    And the supplier should be assigned to the 'jurisdictions' in 'Wales' as follows:
      | Isle of Anglesey              |
      | Mid Wales                     |
      | South West Wales              |
      | Swansea                       |
      | Cardiff and Vale of Glamorgan |
      | Gwent Valleys                 |
    And the supplier should be assigned to the 'jurisdictions' in 'Scotland' as follows:
      | Clackmannanshire and Fife                   |
      | Perth and Kinross, and Stirling             |
      | East Lothian and Midlothian                 |
      | Falkirk                                     |
      | City of Edinburgh                           |
      | West Lothian                                |
      | East Dunbartonshire and West Dunbartonshire |
      | Glasgow City                                |
      | Dumfries and Galloway                       |
      | South Ayrshire                              |
      | South Lanarkshire                           |
    And the supplier should be assigned to the 'jurisdictions' in 'Northern Ireland' as follows:
      | Belfast                  |
      | Newry, Mourne and Down   |
      | Ards and North Down      |
      | Derry City and Strabane  |
      | Causeway Coast and Glens |
      | Lisburn and Castlereagh  |
      | Mid and East Antrim      |
      | Fermanagh and Omagh      |
    And the supplier should be assigned to the 'jurisdictions' in 'National' as follows:
      |  |
    And the supplier should be assigned to the 'jurisdictions' in 'Overseas' as follows:
      | International coverage |
