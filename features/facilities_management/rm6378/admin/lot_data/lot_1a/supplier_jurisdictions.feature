Feature: Facilities Management - Admin - Supplier lot data - 1a - View jurisdictions

  Background: Go to jurisdictions
    Given I sign in as an admin for the 'RM6378' framework in 'Facilities Management'
    And I click on 'Manage supplier data'
    Then I am on the 'Supplier data' page
    And I click on 'View lot data' for 'BEATTY AND SONS'
    Then I am on the 'Supplier lot data' page
    And the caption is 'BEATTY AND SONS'
    And I click on 'View jurisdictions' for the lot 'Lot 1a - Total Facilities Management'
    Then I am on the 'Lot 1a - Total Facilities Management' page
    And the caption is 'BEATTY AND SONS'
    And the supplier should be assigned to the 'jurisdictions' in 'North East (England)' as follows:
      | Northumberland, Durham and Tyne & Wear |
    And the supplier should be assigned to the 'jurisdictions' in 'North West (England)' as follows:
      | Cumbria            |
      | Greater Manchester |
      | Lancashire         |
      | Cheshire           |
      | Merseyside         |
    And the supplier should be assigned to the 'jurisdictions' in 'Yorkshire & The Humber' as follows:
      | North Yorkshire |
    And the supplier should be assigned to the 'jurisdictions' in 'East Midlands (England)' as follows:
      | Lincolnshire |
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
      | Outer London - East and North East |
      | Outer London - South               |
      | Outer London - West and North West |
    And the supplier should be assigned to the 'jurisdictions' in 'South East (England)' as follows:
      | Berkshire, Buckinghamshire and Oxfordshire |
      | Surrey, East and West Sussex               |
      | Hampshire and Isle of Wight                |
      | Kent                                       |
    And the supplier should be assigned to the 'jurisdictions' in 'South West (England)' as follows:
      | Devon                               |
      | North Somerset, Somerset and Dorset |
      | Gloucestershire and Wiltshire       |
    And the supplier should be assigned to the 'jurisdictions' in 'Wales' as follows:
      | Isle of Anglesey              |
      | Flintshire and Wrexham        |
      | Mid Wales                     |
      | South West Wales              |
      | Cardiff and Vale of Glamorgan |
    And the supplier should be assigned to the 'jurisdictions' in 'Scotland' as follows:
      | Clackmannanshire and Fife                       |
      | Perth and Kinross, and Stirling                 |
      | Angus and Dundee City                           |
      | East Lothian and Midlothian                     |
      | City of Edinburgh                               |
      | West Lothian                                    |
      | Inverclyde, East Renfrewshire, and Renfrewshire |
      | North Lanarkshire                               |
      | South Ayrshire                                  |
      | South Lanarkshire                               |
    And the supplier should be assigned to the 'jurisdictions' in 'Northern Ireland' as follows:
      | Belfast                  |
      | Newry, Mourne and Down   |
      | Derry City and Strabane  |
      | Mid Ulster               |
      | Causeway Coast and Glens |
      | Antrim and Newtownabbey  |
      | Lisburn and Castlereagh  |
      | Fermanagh and Omagh      |
    And the supplier should be assigned to the 'jurisdictions' in 'National' as follows:
      | National coverage (all of the above) |
    And the supplier should be assigned to the 'jurisdictions' in 'Overseas' as follows:
      |  |
    Given I click on 'Change (Jurisdictions the supplier can offer)'
    Then I am on the 'Edit jurisdiction selection' page
    And the caption is 'BEATTY AND SONS'

  Scenario: Update jurisdictions
    When I select the following items:
      | Tees Valley                  |
      | Central Valleys and Bridgend |
    When I deselect the following items:
      | Greater Manchester              |
      | Cambridgeshire and Peterborough |
      | South West Wales                |
    Then I click on 'Save and return'
    Then I am on the 'Lot 1a - Total Facilities Management View jurisdictions' page
    And the caption is 'BEATTY AND SONS'
    And the supplier should be assigned to the 'jurisdictions' in 'North East (England)' as follows:
      | Tees Valley                            |
      | Northumberland, Durham and Tyne & Wear |
    And the supplier should be assigned to the 'jurisdictions' in 'North West (England)' as follows:
      | Cumbria    |
      | Lancashire |
      | Cheshire   |
      | Merseyside |
    And the supplier should be assigned to the 'jurisdictions' in 'Yorkshire & The Humber' as follows:
      | North Yorkshire |
    And the supplier should be assigned to the 'jurisdictions' in 'East Midlands (England)' as follows:
      | Lincolnshire |
    And the supplier should be assigned to the 'jurisdictions' in 'West Midlands (England)' as follows:
      | Herefordshire, Worcestershire and Warwickshire |
      | Shropshire and Staffordshire                   |
      | West Midlands                                  |
    And the supplier should be assigned to the 'jurisdictions' in 'East (England)' as follows:
      | Bedfordshire and Hertfordshire |
      | Essex                          |
      | Norfolk                        |
      | Suffolk                        |
    And the supplier should be assigned to the 'jurisdictions' in 'London' as follows:
      | Inner London - West                |
      | Outer London - East and North East |
      | Outer London - South               |
      | Outer London - West and North West |
    And the supplier should be assigned to the 'jurisdictions' in 'South East (England)' as follows:
      | Berkshire, Buckinghamshire and Oxfordshire |
      | Surrey, East and West Sussex               |
      | Hampshire and Isle of Wight                |
      | Kent                                       |
    And the supplier should be assigned to the 'jurisdictions' in 'South West (England)' as follows:
      | Devon                               |
      | North Somerset, Somerset and Dorset |
      | Gloucestershire and Wiltshire       |
    And the supplier should be assigned to the 'jurisdictions' in 'Wales' as follows:
      | Isle of Anglesey              |
      | Flintshire and Wrexham        |
      | Mid Wales                     |
      | Central Valleys and Bridgend  |
      | Cardiff and Vale of Glamorgan |
    And the supplier should be assigned to the 'jurisdictions' in 'Scotland' as follows:
      | Clackmannanshire and Fife                       |
      | Perth and Kinross, and Stirling                 |
      | Angus and Dundee City                           |
      | East Lothian and Midlothian                     |
      | City of Edinburgh                               |
      | West Lothian                                    |
      | Inverclyde, East Renfrewshire, and Renfrewshire |
      | North Lanarkshire                               |
      | South Ayrshire                                  |
      | South Lanarkshire                               |
    And the supplier should be assigned to the 'jurisdictions' in 'Northern Ireland' as follows:
      | Belfast                  |
      | Newry, Mourne and Down   |
      | Derry City and Strabane  |
      | Mid Ulster               |
      | Causeway Coast and Glens |
      | Antrim and Newtownabbey  |
      | Lisburn and Castlereagh  |
      | Fermanagh and Omagh      |
    And the supplier should be assigned to the 'jurisdictions' in 'National' as follows:
      | National coverage (all of the above) |
    And the supplier should be assigned to the 'jurisdictions' in 'Overseas' as follows:
      |  |

  Scenario: Remove all jurisdictions
    When I deselect the following items:
      | Northumberland, Durham and Tyne & Wear          |
      | Cumbria                                         |
      | Greater Manchester                              |
      | Lancashire                                      |
      | Cheshire                                        |
      | Merseyside                                      |
      | North Yorkshire                                 |
      | Lincolnshire                                    |
      | Herefordshire, Worcestershire and Warwickshire  |
      | Shropshire and Staffordshire                    |
      | West Midlands                                   |
      | Bedfordshire and Hertfordshire                  |
      | Essex                                           |
      | Cambridgeshire and Peterborough                 |
      | Norfolk                                         |
      | Suffolk                                         |
      | Inner London - West                             |
      | Outer London - East and North East              |
      | Outer London - South                            |
      | Outer London - West and North West              |
      | Berkshire, Buckinghamshire and Oxfordshire      |
      | Surrey, East and West Sussex                    |
      | Hampshire and Isle of Wight                     |
      | Kent                                            |
      | Devon                                           |
      | North Somerset, Somerset and Dorset             |
      | Gloucestershire and Wiltshire                   |
      | Isle of Anglesey                                |
      | Flintshire and Wrexham                          |
      | Mid Wales                                       |
      | South West Wales                                |
      | Cardiff and Vale of Glamorgan                   |
      | Clackmannanshire and Fife                       |
      | Perth and Kinross, and Stirling                 |
      | Angus and Dundee City                           |
      | East Lothian and Midlothian                     |
      | City of Edinburgh                               |
      | West Lothian                                    |
      | Inverclyde, East Renfrewshire, and Renfrewshire |
      | North Lanarkshire                               |
      | South Ayrshire                                  |
      | South Lanarkshire                               |
      | Belfast                                         |
      | Newry, Mourne and Down                          |
      | Derry City and Strabane                         |
      | Mid Ulster                                      |
      | Causeway Coast and Glens                        |
      | Antrim and Newtownabbey                         |
      | Lisburn and Castlereagh                         |
      | Fermanagh and Omagh                             |
      | National coverage (all of the above)            |
    Then I click on 'Save and return'
    Then I am on the 'Lot 1a - Total Facilities Management View jurisdictions' page
    And the caption is 'BEATTY AND SONS'
    And the supplier should not be assigned any 'jurisdictions' with the following message:
      | The supplier does not offer any jurisdictions in this lot |
