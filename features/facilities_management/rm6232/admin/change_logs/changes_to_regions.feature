Feature: Change log for supplier regions

  Scenario: Changes to the supplier regions are logged
    Given I sign in as an admin and navigate to the 'RM6232' dashboard
    And I click on 'Supplier data'
    Then I am on the 'Supplier data' page
    Then I click on 'View lot data' for 'Muller Inc'
    And I change the 'regions' for lot '2b'
    Then I am on the 'Lot 2b regions' page
    And I select the following items:
      | Northumberland and Tyne and Wear  |
      | West Midlands (county)            |
      | Surrey, East and West Sussex      |
    And I deselect the following items:
      | Tees Valley and Durham  |
      | Flintshire and Wrexham  |
      | Shetland Islands        |
    And I click on 'Save and return'
    And I am on the 'View lot data' page
    And I change the 'regions' for lot '3b'
    Then I am on the 'Lot 3b regions' page
    And I select the following items:
      | Cumbria     |
      | Cheshire    |
      | Merseyside  |
    And I click on 'Save and return'
    And I am on the 'View lot data' page
    And I change the 'regions' for lot '2c'
    Then I am on the 'Lot 2c regions' page
    And I deselect the following items:
      | East Anglia                     |
      | Bedfordshire and Hertfordshire  |
      | Essex                           |
    And I click on 'Save and return'
    And I am on the 'View lot data' page
    And I click on 'Home'
    Then I am on the 'RM6232 administration dashboard' page
    And I click on 'Supplier data change log'
    Then I am on the 'Supplier data change log' page
    And I should see 4 logs
    And log number 1 has the user 'me'
    And log number 1 has the change type 'Regions'
    And log number 2 has the user 'me'
    And log number 2 has the change type 'Regions'
    And log number 3 has the user 'me'
    And log number 3 has the change type 'Regions'
    And I click on log number 3
    Then I am on the 'Changes to supplier regions' page
    And the supplier who was changed is 'Muller Inc'
    And the change was made by 'me'
    And the change was made in lot '2b'
    And the following items were added:
      | Northumberland and Tyne and Wear  |
      | West Midlands (county)            |
      | Surrey, East and West Sussex      |
    And the following items were removed:
      | Tees Valley and Durham  |
      | Flintshire and Wrexham  |
      | Shetland Islands        | 
    Then I click on 'Supplier data change log'
    And I am on the 'Supplier data change log' page
    And I click on log number 2
    Then I am on the 'Changes to supplier regions' page
    And the supplier who was changed is 'Muller Inc'
    And the change was made by 'me'
    And the change was made in lot '3b'
    And the following items were added:
      | Cumbria     |
      | Cheshire    |
      | Merseyside  |
    Then I click on 'Supplier data change log'
    And I am on the 'Supplier data change log' page
    And I click on log number 1
    Then I am on the 'Changes to supplier regions' page
    And the supplier who was changed is 'Muller Inc'
    And the change was made by 'me'
    And the change was made in lot '2c'
    And the following items were removed:
      | East Anglia                     |
      | Bedfordshire and Hertfordshire  |
      | Essex                           |
