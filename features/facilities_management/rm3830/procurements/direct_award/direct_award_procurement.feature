@javascript
Feature: Procurement journey - Direct Award

  Scenario: Taking a procurement through to direct award
    Given I sign in and navigate to my account for 'RM3830'
    And I have buildings
    And I click on 'Start a procurement'
    Then I am on the 'What happens next' page
    And I click on 'Continue'
    Then I am on the 'Contract name' page
    And I enter 'Test procurement' into the contract name field
    And I click on 'Save and continue'
    Then I am on the 'Requirements' page
    And I should see my procurement name
    And I click on 'Estimated annual cost'
    Then I am on the 'Estimated annual cost' page
    And I select 'Yes' for estimated annual cost known
    And I enter '123456' for estimated annual cost
    And I click on 'Save and return'
    Then I am on the 'Requirements' page
    And I click on 'TUPE'
    Then I am on the 'TUPE' page
    And I select 'No' for TUPE required
    And I click on 'Save and return'
    Then I am on the 'Requirements' page
    And I click on 'Contract period'
    Then I am on the 'Contract period' page
    And I enter '3' years and '2' months for the contract period
    And I enter 'today' as the inital call-off period start date
    And I select 'No' for mobilisation period required
    And I select 'No' for optional extension required
    And I click on 'Save and return'
    Then I am on the 'Contract period summary' page
    And I click on 'Return to requirements'
    Then I am on the 'Requirements' page
    And I click on 'Services'
    Then I am on the 'Services' page
    And I show all sections
    Then I select the following items:
      | Mechanical and electrical engineering maintenance   |
      | Portable appliance testing                          |
      | Routine cleaning                                    |
      | General waste                                       |
      | Reception service                                   |
    And I click on 'Save and return'
    Then I am on the 'Services summary' page
    And I should see the following seleceted services in the summary:
      | Mechanical and electrical engineering maintenance   |
      | Portable appliance testing                          |
      | Routine cleaning                                    |
      | Reception service                                   |
      | General waste                                       |
    And I click on 'Return to requirements'
    Then I am on the 'Requirements' page
    And I click on 'Buildings'
    Then I am on the 'Buildings' page
    And I find and select the following buildings:
      | Test building         |
      | Test London building  |
    And I click on 'Save and return'
    Then I am on the 'Buildings summary' page
    And I should see the following seleceted buildings in the summary:
      | Test building         |
      | Test London building  |
    And I click on 'Return to requirements'
    Then I am on the 'Requirements' page
    And I click on 'Assigning services to buildings'
    Then I am on the 'Assigning services to buildings summary' page
    And I click on 'Test building'
    And I select all services for the building
    And I click on 'Save and return'
    Then I am on the 'Assigning services to buildings summary' page
    And I click on 'Test London building'
    And I select the following service codes for the building:
      | C.1 |
      | E.4 |
      | I.1 |
    And I click on 'Save and return'
    Then I am on the 'Assigning services to buildings summary' page
    And I click on 'Return to requirements'
    Then I am on the 'Requirements' page
    And I click on 'Service requirements'
    Then I am on the 'Service requirements' page
    And I click on 'Test building'
    Then I am on the page with secondary heading 'Service requirements'
    And I choose to answer the service volume question for 'Portable appliance testing'
    Then I am on the page with secondary heading 'Portable appliance testing'
    And I enter '500' for the service volume
    Then I click on 'Save and return'
    Then I am on the page with secondary heading 'Service requirements'
    And I choose to answer the service volume question for 'Routine cleaning'
    Then I am on the page with secondary heading 'Routine cleaning'
    And I enter '456' for the service volume
    Then I click on 'Save and return'
    Then I am on the page with secondary heading 'Service requirements'
    And I choose to answer the first Service volume question for 'Reception service'
    Then I am on the page with secondary heading 'Reception service'
    And I enter '4500' for the number of hours per year
    And I enter the following for the detail of requirement:
      | This is some details of requirement |
      | And it goes over two lines          |
    Then I click on 'Save and return'
    Then I am on the page with secondary heading 'Service requirements'
    And I choose to answer the service volume question for 'General waste'
    Then I am on the page with secondary heading 'General waste'
    And I enter '123' for the service volume
    Then I click on 'Save and return'
    Then I am on the page with secondary heading 'Service requirements'
    And I choose to answer the service standard question for 'Mechanical and electrical engineering maintenance'
    Then I am on the page with secondary heading 'Mechanical and electrical engineering maintenance'
    And I select Standard 'A'
    Then I click on 'Save and return'
    Then I am on the page with secondary heading 'Service requirements'
    And I choose to answer the service standard question for 'Routine cleaning'
    And I select Standard 'A'
    Then I click on 'Save and return'
    Then I am on the page with secondary heading 'Service requirements'
    And the building should have the status 'COMPLETE'
    And I click on 'Return to service requirements summary'
    Then I am on the 'Service requirements' page
    And I click on 'Test London building'
    And I choose to answer the service volume question for 'Portable appliance testing'
    Then I am on the page with secondary heading 'Portable appliance testing'
    And I enter '500' for the service volume
    Then I click on 'Save and return'
    And I choose to answer the first Service volume question for 'Reception service'
    Then I am on the page with secondary heading 'Reception service'
    And I enter '600' for the number of hours per year
    And I enter the following for the detail of requirement:
      | This is some details of requirement and it goes over one line |
    Then I click on 'Save and return'
    Then I am on the page with secondary heading 'Service requirements'
    And I choose to answer the service standard question for 'Mechanical and electrical engineering maintenance'
    Then I am on the page with secondary heading 'Mechanical and electrical engineering maintenance'
    And I select Standard 'A'
    Then I click on 'Save and return'
    Then I am on the page with secondary heading 'Service requirements'
    And the building should have the status 'COMPLETE'
    And I click on 'Return to service requirements summary'
    Then I am on the 'Service requirements' page
    And I click on 'Return to requirements'
    Then I am on the 'Requirements' page
    And everything is completed
    And I click on 'Continue to results'
    Then I am on the 'Results' page
    And Direct award is an available route to market
    And I select 'Direct award' on results
    And I click on 'Continue'
    And I am on the 'Direct award pricing' page
