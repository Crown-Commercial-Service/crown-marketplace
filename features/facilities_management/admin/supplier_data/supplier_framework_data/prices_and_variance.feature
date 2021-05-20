@pipeline
Feature: Prices and variance

  Scenario: Changing the supplier values changes the results
    Given I sign in as an admin and navigate to my dashboard
    Given I have a procurement in detailed search named 'AV Procurement' with the following services and multiple buildings:
      | C.1 |
      | G.1 |
      | I.1 |
      | K.2 |
      | M.1 |
      | N.1 |
    And I go to the buyer dashboard
    And I click on 'Continue a procurement'
    And I click on 'AV Procurement'
    Then I am on the 'Requirements' page
    And I enter the service requirements for 'Test building' in the assessed value procurement
    And I enter the service requirements for 'Test London building' in the assessed value procurement
    And I click on 'Continue to results'
    Then I am on the 'Results' page
    And the assessed value is '£283,250.47'
    Given I select 'direct award' on results
    And I click on 'Continue'
    Then I am on the 'Direct award pricing' page
    And the selected supplier is 'Kunze, Langworth and Parisian'
    And I click on 'Return to results'
    Then I am on the 'Results' page
    And I click on 'Change requirements'
    Then I am on the 'Requirements' page
    And I go to the admin dashboard
    And I click on 'Supplier framework data'
    Then I am on the 'Supplier framework data' page
    Given I open all sections
    And select 'Services' for sublot '1a' for 'Kunze, Langworth and Parisian'
    Then I am on the 'Sub-lot 1a services, prices, and variances' page
    And I enter '2.4867' into the price for 'C.1 Mechanical and electrical engineering maintenance' under 'Warehouses'
    And I enter '2.4867' into the price for 'C.1 Mechanical and electrical engineering maintenance' under 'Primary School'
    And I enter '19.74' into the price for 'G.1 Routine cleaning' under 'Warehouses'
    And I enter '22.3' into the price for 'G.1 Routine cleaning' under 'Primary School'
    And I enter '11.67' into the price for 'I.1 Reception service' under 'Warehouses'
    And I enter '11.67' into the price for 'I.1 Reception service' under 'Primary School'
    And I enter '165.0' into the price for 'K.2 General waste' under 'Warehouses'
    And I enter '174.0' into the price for 'K.2 General waste' under 'Primary School'
    And I enter '0.003' into the price for 'M.1 CAFM system' under 'Warehouses'
    And I enter '0.018' into the price for 'N.1 Helpdesk services' under 'Primary School'
    And I enter '0.202' into the variance for 'London location percentage variance (%)'
    And I click on 'Save and return to supplier framework data'
    Then I am on the 'Supplier framework data' page
    And I go to the buyer dashboard
    And I click on 'Continue a procurement'
    And I click on 'AV Procurement'
    Then I am on the 'Requirements' page
    And I click on 'Continue to results'
    Then I am on the 'Results' page
    And the assessed value is '£304,354.31'
    Given I select 'direct award' on results
    And I click on 'Continue'
    Then I am on the 'Direct award pricing' page
    And the selected supplier is 'Kemmer Group'