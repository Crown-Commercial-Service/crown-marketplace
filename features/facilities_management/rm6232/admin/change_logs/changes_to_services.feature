Feature: Change log for supplier services

  Scenario: Changes to the supplier services are logged
    Given I sign in as an admin and navigate to the 'RM6232' dashboard
    And I click on 'Supplier data'
    Then I am on the 'Supplier data' page
    Then I click on 'View lot data' for 'Green Group'
    And I change the 'services' for lot '1c'
    Then I am on the 'Lot 1c services' page
    And I select the following items:
      | E.16 Television cabling maintenance |
      | J.15 Portable washroom solutions    |
      | N.8 Footwear cobbling Services      |
    And I deselect the following items:
      | G.8 Cut flowers and Christmas trees                         |
      | I.10 Reactive cleaning (outside cleaning operational hours) |
      | P.8 Accommodation Stores Service                            |
    And I click on 'Save and return'
    And I am on the 'View lot data' page
    And I change the 'services' for lot '3c'
    Then I am on the 'Lot 3c services' page
    And I select the following items:
      | L.14 Remote CCTV / alarm monitoring |
      | M.5 Hazardous waste                 |
    And I click on 'Save and return'
    And I am on the 'View lot data' page
    And I change the 'services' for lot '2c'
    Then I am on the 'Lot 2c services' page
    And I deselect the following items:
      | E.19 Voice announcement system maintenance |
    And I click on 'Save and return'
    And I am on the 'View lot data' page
    And I click on 'Home'
    Then I am on the 'RM6232 administration dashboard' page
    And I click on 'Supplier data change log'
    Then I am on the 'Supplier data change log' page
    And I should see 4 logs
    And log number 1 has the user 'me'
    And log number 1 has the change type 'Services'
    And log number 2 has the user 'me'
    And log number 2 has the change type 'Services'
    And log number 3 has the user 'me'
    And log number 3 has the change type 'Services'
    And I click on log number 3
    Then I am on the 'Changes to supplier services' page
    And the supplier who was changed is 'Green Group'
    And the change was made by 'me'
    And the change was made in lot '1c'
    And the following items were added:
      | E.16 Television cabling maintenance |
      | J.15 Portable washroom solutions    |
      | N.8 Footwear cobbling Services      |
    And the following items were removed:
      | G.8 Cut flowers and Christmas trees                         |
      | I.10 Reactive cleaning (outside cleaning operational hours) |
      | P.8 Accommodation Stores Service                            |
    Then I click on 'Supplier data change log'
    And I am on the 'Supplier data change log' page
    And I click on log number 2
    Then I am on the 'Changes to supplier services' page
    And the supplier who was changed is 'Green Group'
    And the change was made by 'me'
    And the change was made in lot '3c'
    And the following items were added:
      | L.14 Remote CCTV / alarm monitoring |
      | M.5 Hazardous waste                 |
    Then I click on 'Supplier data change log'
    And I am on the 'Supplier data change log' page
    And I click on log number 1
    Then I am on the 'Changes to supplier services' page
    And the supplier who was changed is 'Green Group'
    And the change was made by 'me'
    And the change was made in lot '2c'
    And the following items were removed:
      | E.19 Voice announcement system maintenance |
