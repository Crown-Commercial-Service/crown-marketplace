Feature: Security policy document validations

  Background: Navigate to the Security policy document question
    Given I sign in and navigate to my account for 'RM3830'
    And I have a procurement in DA draft at the 'contract_details' stage named 'Security policy document procurement'
    When I navigate to the procurement 'Security policy document procurement'
    Then I am on the 'Contract details' page
    And I answer the 'Security policy' contract detail question
    Then I am on the 'Security policy document' page

  Scenario: Nothing is selected
    When I click on 'Save and return'
    Then I should see the following error messages:
      | Select one option |

  Scenario: Yes is selected but nothing entered
    Given I select 'Yes' for the security policy document question
    When I click on 'Save and return'
    Then I should see the following error messages:
      | Enter a security policy document name           |
      | Enter a security policy document version number |
      | The selected file is empty                      |

  Scenario: Yes is selected and security policy document has the worng format
    Given I select 'Yes' for the security policy document question
    And I enter 'Test' for the security policy document 'name'
    And I enter '12' for the security policy document 'number'
    And I enter '20/02/2020' for the security policy document 'date'
    And I upload security policy document that is 'invalid'
    When I click on 'Save and return'
    Then I should see the following error messages:
      | The selected file must be a DOC, DOCX or PDF  |

  Scenario: Yes is selected and security policy document date is invalid
    Given I select 'Yes' for the security policy document question
    And I enter 'Test' for the security policy document 'name'
    And I enter '12' for the security policy document 'number'
    And I enter '20/20/2020' for the security policy document 'date'
    And I upload security policy document that is 'valid'
    When I click on 'Save and return'
    Then I should see the following error messages:
      | The selected date is not valid  |