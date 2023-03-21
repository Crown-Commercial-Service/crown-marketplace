Feature: Volumes

  Background: Navigate to the Service requirements page
    Given I sign in and navigate to my account for 'RM3830'
    And I have a procurement in detailed search named 'Service volumes procurement' with the following services:
      | E.4 |
      | G.1 |
      | K.1 |
      | K.2 |
      | K.7 |
    And I navigate to the service requirements page

  Scenario: Make sure the volume questions have the right units
    Given I choose to answer the service volume question for 'Portable appliance testing'
    And I am on the page with secondary heading 'Portable appliance testing'
    Then the volume question is 'How many portable appliances will require testing each year within this building?'
    And the volume unit is 'appliances'
    When I click on the 'Return to service requirements' return link
    Then I am on the page with secondary heading 'Service requirements'
    Given I choose to answer the service volume question for 'Routine cleaning'
    And I am on the page with secondary heading 'Routine cleaning'
    Then the volume question is 'How many building occupants (building users) are there in this building?'
    And the volume unit is 'occupants'
    When I click on the 'Return to service requirements' back link
    Then I am on the page with secondary heading 'Service requirements'
    Given I choose to answer the service volume question for 'Classified waste'
    And I am on the page with secondary heading 'Classified waste'
    Then the volume question is 'How many consoles are to be serviced each year within this building?'
    And the volume unit is 'consoles'
    When I click on the 'Return to service requirements' return link
    Then I am on the page with secondary heading 'Service requirements'
    Given I choose to answer the service volume question for 'General waste'
    And I am on the page with secondary heading 'General waste'
    Then the volume question is 'How many tonnes are to be collected, stored and removed each year within this building?'
    And the volume unit is 'tonnes'
    When I click on the 'Return to service requirements' back link
    Then I am on the page with secondary heading 'Service requirements'
    Given I choose to answer the service volume question for 'Feminine hygiene waste'
    And I am on the page with secondary heading 'Feminine hygiene waste'
    Then the volume question is 'How many units are to be serviced each year within this building?'
    And the volume unit is 'units'

  Scenario: The answer to the volume question saves
    Given I choose to answer the service volume question for 'Portable appliance testing'
    And I am on the page with secondary heading 'Portable appliance testing'
    Given I enter '123' for the service volume
    And I click on 'Save and return'
    Then I am on the page with secondary heading 'Service requirements'
    And the volume for 'Portable appliance testing' is 123
    Given I choose to answer the service volume question for 'Routine cleaning'
    And I am on the page with secondary heading 'Routine cleaning'
    Given I enter '456' for the service volume
    And I click on 'Save and return'
    Then I am on the page with secondary heading 'Service requirements'
    And the volume for 'Routine cleaning' is 456
    Given I choose to answer the service volume question for 'Classified waste'
    And I am on the page with secondary heading 'Classified waste'
    Given I enter '789' for the service volume
    And I click on 'Save and return'
    Then I am on the page with secondary heading 'Service requirements'
    And the volume for 'Classified waste' is 789
    Given I choose to answer the service volume question for 'General waste'
    And I am on the page with secondary heading 'General waste'
    Given I enter '123' for the service volume
    And I click on 'Save and return'
    Then I am on the page with secondary heading 'Service requirements'
    And the volume for 'General waste' is 123
    Given I choose to answer the service volume question for 'Feminine hygiene waste'
    And I am on the page with secondary heading 'Feminine hygiene waste'
    Given I enter '456' for the service volume
    And I click on 'Save and return'
    Then I am on the page with secondary heading 'Service requirements'
    And the volume for 'Feminine hygiene waste' is 456
    