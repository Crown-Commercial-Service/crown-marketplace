@accessibility @javascript
Feature: Contract details accessibility

  Background: Navigate to the contract details page
    Given I sign in and navigate to my account
    And I have a procurement in DA draft at the 'contract_details' stage named 'Contract detail procurement'
    When I navigate to the procurement 'Contract detail procurement'
    Then I am on the 'Contract details' page

  Scenario: Contract details page
    Then the page should be axe clean

  Scenario: Payment method page
    Given I answer the 'Payment method' contract detail question
    Then I am on the 'Payment method' page
    Then the page should be axe clean

  Scenario: Invoicing contact details pages
    Given I answer the 'Invoicing contact details' contract detail question
    Then I am on the 'Invoicing contact details' page
    Then the page should be axe clean
    Given I select 'Enter a new invoicing contact' for the contact details
    And I click on the button with text 'Continue'
    Then I am on the 'New invoicing contact details' page
    Then the page should be axe clean
    And I enter 'XC2 0MA' for the invoicing contact detail 'Postcode'
    And I click on 'Find address'
    And I click on the link with text 'Enter address manually, if you can’t find address'
    Then I am on the 'Add address' page
    Then the page should be axe clean

  Scenario: Authorised representative pages
    Given I answer the 'Authorised representative details' contract detail question
    Then I am on the 'Authorised representative details' page
    Then the page should be axe clean
    Given I select 'Enter a new authorised representative' for the contact details
    And I click on the button with text 'Continue'
    Then I am on the 'New authorised representative details' page
    Then the page should be axe clean
    And I enter 'XC2 0MA' for the authorised representative detail 'Postcode'
    And I click on 'Find address'
    And I click on the link with text 'Enter address manually, if you can’t find address'
    Then I am on the 'Add address' page
    Then the page should be axe clean

  Scenario: Notices contact details pages
    Given I answer the 'Notices contact details' contract detail question
    Then I am on the 'Notices contact details' page
    Then the page should be axe clean
    Given I select 'Enter a new contact for notices' for the contact details
    And I click on the button with text 'Continue'
    Then I am on the 'New notices contact details' page
    Then the page should be axe clean
    And I enter 'XC2 0MA' for the notices contact detail 'Postcode'
    And I click on 'Find address'
    And I click on the link with text 'Enter address manually, if you can’t find address'
    Then I am on the 'Add address' page
    Then the page should be axe clean
  
  Scenario: Security policy document page
    Given I answer the 'Security policy' contract detail question
    Then I am on the 'Security policy document' page
    Then the page should be axe clean
    And I select 'Yes' for the security policy document question
    Then the page should be axe clean

  Scenario: Local government pension scheme pages
    Given I answer the 'Local Government Pension Scheme' contract detail question
    Then I am on the 'Local Government Pension Scheme' page
    And the page should be axe clean
    Given I select 'Yes' for the LGPS question
    And I click on 'Save and continue'
    Then I am on the 'Pension funds' page
    And the page should be axe clean

  Scenario: Governing law page
    Given I answer the 'Governing law' contract detail question
    Then I am on the 'Governing law' page
    And the page should be axe clean