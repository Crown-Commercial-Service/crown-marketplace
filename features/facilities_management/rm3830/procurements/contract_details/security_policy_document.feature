Feature: Security policy document

  Background: Navigate to the Security policy document question
    Given I sign in and navigate to my account for 'RM3830'
    And I have a procurement in DA draft at the 'contract_details' stage named 'Security policy document procurement'
    When I navigate to the procurement 'Security policy document procurement'
    Then I am on the 'Contract details' page
    And I answer the 'Security policy' contract detail question
    Then I am on the 'Security policy document' page

  Scenario: When no is selected
    Given I select 'No' for the security policy document question
    When I click on 'Save and return'
    Then I am on the 'Contract details' page
    And my answer to the 'Security policy' contract detail question is 'Not applicable'

  Scenario: When yes is selected
    Given I select 'Yes' for the security policy document question
    And I enter 'Test' for the security policy document 'name'
    And I enter '12' for the security policy document 'number'
    And I upload security policy document that is 'valid'
    When I click on 'Save and return'
    Then I am on the 'Contract details' page
    And my answer to the 'Security policy' contract detail question is 'Attachment 1 - About the Direct Award v3.0.pdf'

  Scenario: When the answer is changed
    And I select 'Yes' for the security policy document question
    And I enter 'Test' for the security policy document 'name'
    And I enter '12' for the security policy document 'number'
    And I upload security policy document that is 'valid'
    When I click on 'Save and return'
    Then I am on the 'Contract details' page
    And my answer to the 'Security policy' contract detail question is 'Attachment 1 - About the Direct Award v3.0.pdf'
    Given I answer the 'Security policy' contract detail question
    Then I am on the 'Security policy document' page
    Given I select 'No' for the security policy document question
    When I click on 'Save and return'
    Then I am on the 'Contract details' page
    And my answer to the 'Security policy' contract detail question is 'Not applicable'

  Scenario: Return links work
    Given I click on the 'Return to contract details' back link
    Then I am on the 'Contract details' page
    Then I answer the 'Security policy' contract detail question
    And I am on the 'Security policy document' page
    When I click on the 'Return to contract details' return link
    Then I am on the 'Contract details' page