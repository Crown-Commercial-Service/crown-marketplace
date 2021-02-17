Feature: Create a procurement

  Background: Navigate to create a procurement
    Given I sign in and navigate to my account
    And I click on 'Start a procurement'
    Then I am on the 'What happens next' page
    And I click on 'Continue'
    Then I am on the 'Contract name' page

  Scenario Outline: Validate contract name
    And I have a procurement with the name 'Taken contract name'
    And I enter '<contract_name>' into the contract name field
    And I click on 'Save and continue'
    Then I should see the following error messages:
      | <error_message> |

    Examples:
      | contract_name       | error_message                         |
      |                     | Enter your contract name              |
      | Taken contract name | This contract name is already in use  |

  Scenario: Create a procurement
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