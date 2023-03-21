Feature: Create a procurement
  
  Scenario: Create a procurement
    Given I sign in and navigate to my account for 'RM3830'
    And I click on 'Start a procurement'
    Then I am on the 'What happens next' page
    And I click on 'Continue'
    Then I am on the 'Contract name' page
    And I enter 'Test procurement 1' into the contract name field
    And I click on 'Save and continue'
    Then I am on the 'Requirements' page
    And I should see my procurement name
    And 'Contract name' should have the status 'COMPLETED' in 'Contract details'
    And 'Estimated annual cost' should have the status 'NOT STARTED' in 'Contract details'
    And 'TUPE' should have the status 'NOT STARTED' in 'Contract details'
    And 'Contract period' should have the status 'NOT STARTED' in 'Contract details'
    And 'Services' should have the status 'NOT STARTED' in 'Services and buildings'
    And 'Buildings' should have the status 'NOT STARTED' in 'Services and buildings'
    And 'Assigning services to buildings' should have the status 'CANNOT START YET' in 'Services and buildings'
    And 'Service requirements' should have the status 'CANNOT START YET' in 'Services and buildings'