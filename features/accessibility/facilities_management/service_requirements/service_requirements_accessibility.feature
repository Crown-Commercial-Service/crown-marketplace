@accessibility @javascript
Feature: Service requirements accessibility

  Background: I am logged in
    Given I sign in and navigate to my account

  Scenario: Service requirements page
    Given I have a procurement in detailed search named 'Area procurement' with the following services:
      | C.1 |
      | G.5 |
    And I navigate to the service requirements page
    Then the page should be axe clean

  Scenario: Internal and external area page
    Given I have a procurement in detailed search named 'Area procurement' with the following services:
      | C.1 |
      | G.5 |
    And I navigate to the service requirements page
    And I choose to answer the service volume question for 'Mechanical and electrical engineering maintenance'
    Then I am on the Internal and external areas page in service requirements
    Then the page should be axe clean

  Scenario: Lifts page
    And I have a procurement in detailed search named 'Lifts procurement' with the following services:
      | C.5 |
    And I navigate to the service requirements page
    And I choose to answer the service volume question for 'Lifts, hoists & conveyance systems maintenance'
    Then I am on the page with secondary heading 'Lifts, hoists & conveyance systems maintenance'
    Then the page should be axe clean

  Scenario: Service hourse page
    And I have a procurement in detailed search named 'Service hours procurement' with the following services:
      | I.4 |
    And I navigate to the service requirements page
    And I choose to answer the service volume question for 'Voice announcement system operation'
    Then I am on the page with secondary heading 'Voice announcement system operation'
    Then the page should be axe clean

  Scenario: Service standards page
    And I have a procurement in detailed search named 'Service standard procurement' with the following services:
      | C.5 |
      | G.5 |
      | C.7 |
    And I navigate to the service requirements page
    Given I choose to answer the service standard question for 'Lifts, hoists & conveyance systems maintenance'
    Then I am on the page with secondary heading 'Lifts, hoists & conveyance systems maintenance'
    Then the page should be axe clean
    Given I click on the 'Return to service requirements' return link
    Then I am on the page with secondary heading 'Service requirements'
    Given I choose to answer the service standard question for 'Cleaning of external areas'
    Then I am on the page with secondary heading 'Cleaning of external areas'
    Then the page should be axe clean
    Given I click on the 'Return to service requirements' back link
    Then I am on the page with secondary heading 'Service requirements'
    Given I choose to answer the service standard question for 'Internal & external building fabric maintenance'
    Then I am on the page with secondary heading 'Internal & external building fabric maintenance'
    Then the page should be axe clean

  Scenario: Service volumes page
    And I have a procurement in detailed search named 'Service volumes procurement' with the following services:
      | E.4 |
      | G.1 |
      | K.1 |
      | K.2 |
      | K.7 |
    And I navigate to the service requirements page
    Given I choose to answer the service volume question for 'Portable appliance testing'
    And I am on the page with secondary heading 'Portable appliance testing'
    Then the page should be axe clean
    When I click on the 'Return to service requirements' return link
    Then I am on the page with secondary heading 'Service requirements'
    Given I choose to answer the service volume question for 'Routine cleaning'
    And I am on the page with secondary heading 'Routine cleaning'
    Then the page should be axe clean
    When I click on the 'Return to service requirements' back link
    Then I am on the page with secondary heading 'Service requirements'
    Given I choose to answer the service volume question for 'Classified waste'
    And I am on the page with secondary heading 'Classified waste'
    Then the page should be axe clean
    When I click on the 'Return to service requirements' return link
    Then I am on the page with secondary heading 'Service requirements'
    Given I choose to answer the service volume question for 'General waste'
    And I am on the page with secondary heading 'General waste'
    Then the page should be axe clean
    When I click on the 'Return to service requirements' back link
    Then I am on the page with secondary heading 'Service requirements'
    Given I choose to answer the service volume question for 'Feminine hygiene waste'
    And I am on the page with secondary heading 'Feminine hygiene waste'
    Then the page should be axe clean