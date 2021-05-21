Feature: Assessed value

  Background: Log in and navigate to admin dashboard
    Given I sign in as an admin and navigate to my dashboard
    Given I have a procurement in detailed search named 'AV Procurement' with the following services:
      | C.1 |
      | D.3 |
      | G.1 |
      | I.1 |
      | K.2 |
      | M.1 |
      | N.1 |
    And I go to the buyer dashboard
    And I click on 'Continue a procurement'
    And I click on 'AV Procurement'
    And I click on 'Estimated annual cost'
    And I am on the 'Estimated annual cost' page
    And I enter '150000' for estimated annual cost
    And I click on 'Save and return'
    Then I am on the 'Requirements' page
    And I enter the service requirements for 'Test building' in the assessed value procurement
    And I click on 'Continue to results'
    Then I am on the 'Results' page
    And the assessed value is '£161,289.08'
    And I click on 'Change requirements'
    Then I am on the 'Requirements' page
    And I go to the admin dashboard

  Scenario: When the average framework rates are changed, so is the assessed value
    Given I click on 'Average framework rates'
    Then I am on the 'Average framework rates' page
    Given I enter the servie rate of '5.36' for 'C.1 Mechanical and electrical engineering maintenance'
    And I enter the servie rate of '11.6' for 'I.1 Reception service'
    And I enter the servie rate of '0.0178' for 'M.1 CAFM system'
    And I enter the servie rate of '0.0563' for 'Profit (%)'
    And I enter the servie rate of '29.3' for 'Cleaning consumables per building user (£)'
    And I click on 'Save and return to dashboard'
    Then I am on the 'RM3830 administration dashboard' page
    And I go to the buyer dashboard
    And I click on 'Continue a procurement'
    And I click on 'AV Procurement'
    Then I am on the 'Requirements' page
    And I click on 'Continue to results'
    Then I am on the 'Results' page
    And the assessed value is '£155,651.96'

  Scenario: When the call-off benchmark rates are changed, so is the assessed value
    And I click on 'Call-off benchmark rates'
    Then I am on the 'Call-off benchmark rates' page
    Given I enter the servie rate of '3.44' for 'Mechanical and electrical engineering maintenance' standard 'A'
    And I enter the servie rate of '4.5' for 'Routine cleaning' standard 'A'
    And I enter the servie rate of '14.5' for 'Reception service' standard ''
    And I enter the servie rate of '0.0455' for 'Helpdesk services' standard ''
    And I enter the servie rate of '0.0690' for 'Corporate overhead (%)'
    And I enter the servie rate of '0.0783' for 'Direct award mobilisation (%)'
    And I click on 'Save and return to dashboard'
    Then I am on the 'RM3830 administration dashboard' page
    And I go to the buyer dashboard
    And I click on 'Continue a procurement'
    And I click on 'AV Procurement'
    Then I am on the 'Requirements' page
    And I click on 'Continue to results'
    Then I am on the 'Results' page
    And the assessed value is '£165,776.16'

  Scenario: When both rates are changed, so is the assessed value
    Given I click on 'Average framework rates'
    Then I am on the 'Average framework rates' page
    Given I enter the servie rate of '5.36' for 'C.1 Mechanical and electrical engineering maintenance'
    And I enter the servie rate of '11.6' for 'I.1 Reception service'
    And I enter the servie rate of '0.0178' for 'M.1 CAFM system'
    And I enter the servie rate of '0.0563' for 'Profit (%)'
    And I enter the servie rate of '29.3' for 'Cleaning consumables per building user (£)'
    And I click on 'Save and return to dashboard'
    Then I am on the 'RM3830 administration dashboard' page
    And I click on 'Call-off benchmark rates'
    Then I am on the 'Call-off benchmark rates' page
    Given I enter the servie rate of '3.44' for 'Mechanical and electrical engineering maintenance' standard 'A'
    And I enter the servie rate of '4.5' for 'Routine cleaning' standard 'A'
    And I enter the servie rate of '14.5' for 'Reception service' standard ''
    And I enter the servie rate of '0.0455' for 'Helpdesk services' standard ''
    And I enter the servie rate of '0.0690' for 'Corporate overhead (%)'
    And I enter the servie rate of '0.0783' for 'Direct award mobilisation (%)'
    And I click on 'Save and return to dashboard'
    Then I am on the 'RM3830 administration dashboard' page
    And I go to the buyer dashboard
    And I click on 'Continue a procurement'
    And I click on 'AV Procurement'
    Then I am on the 'Requirements' page
    And I click on 'Continue to results'
    Then I am on the 'Results' page
    And the assessed value is '£160,139.03'