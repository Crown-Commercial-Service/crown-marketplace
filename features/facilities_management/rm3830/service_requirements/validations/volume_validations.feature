Feature: Volume validations

  Scenario Outline: Validating the volume for appliances
    Given I sign in and navigate to my account for 'RM3830'
    And I have a procurement in detailed search named 'Service volumes procurement' with the following services:
      | E.4 |
    And I navigate to the service requirements page
    And I choose to answer the service volume question for 'Portable appliance testing'
    Then I am on the page with secondary heading 'Portable appliance testing'
    Given I enter '<volume>' for the service volume
    And I click on 'Save and return'
    Then I should see the following error messages:
      | <error_message> |

  Examples:
    | volume      | error_message                                                                       |
    |             | Enter number of portable appliances                                                 |
    | 0           | The number of portable appliances must be a whole number between 1 and 999,999,999  |
    | 1000000000  | The number of portable appliances must be a whole number between 1 and 999,999,999  |
    | 306.1       | The number of portable appliances must be a whole number between 1 and 999,999,999  |
    | Mythra      | The number of portable appliances must be a whole number between 1 and 999,999,999  |
 
  Scenario Outline: Validating the volume for building ocupants
    Given I sign in and navigate to my account for 'RM3830'
    And I have a procurement in detailed search named 'Service volumes procurement' with the following services:
      | G.1 |
    And I navigate to the service requirements page
    And I choose to answer the service volume question for 'Routine cleaning'
    Then I am on the page with secondary heading 'Routine cleaning'
    Given I enter '<volume>' for the service volume
    And I click on 'Save and return'
    Then I should see the following error messages:
      | <error_message> |

  Examples:
    | volume      | error_message                                                                     |
    |             | Enter number of building occupants                                                |
    | 0           | The number of building occupants must be a whole number between 1 and 999,999,999 |
    | 1000000000  | The number of building occupants must be a whole number between 1 and 999,999,999 |
    | 306.1       | The number of building occupants must be a whole number between 1 and 999,999,999 |
    | Nia         | The number of building occupants must be a whole number between 1 and 999,999,999 |

  Scenario Outline: Validating the volume for consoles
    Given I sign in and navigate to my account for 'RM3830'
    And I have a procurement in detailed search named 'Service volumes procurement' with the following services:
      | K.1 |
    And I navigate to the service requirements page
    And I choose to answer the service volume question for 'Classified waste'
    Then I am on the page with secondary heading 'Classified waste'
    Given I enter '<volume>' for the service volume
    And I click on 'Save and return'
    Then I should see the following error messages:
      | <error_message> |

  Examples:
    | volume      | error_message                                                           |
    |             | Enter number of consoles                                                |
    | 0           | The number of consoles must be a whole number between 1 and 999,999,999 |
    | 1000000000  | The number of consoles must be a whole number between 1 and 999,999,999 |
    | 306.1       | The number of consoles must be a whole number between 1 and 999,999,999 |
    | Brigid      | The number of consoles must be a whole number between 1 and 999,999,999 |

  Scenario Outline: Validating the volume for tonnes
    Given I sign in and navigate to my account for 'RM3830'
    And I have a procurement in detailed search named 'Service volumes procurement' with the following services:
      | K.2 |
    And I navigate to the service requirements page
    And I choose to answer the service volume question for 'General waste'
    Then I am on the page with secondary heading 'General waste'
    Given I enter '<volume>' for the service volume
    And I click on 'Save and return'
    Then I should see the following error messages:
      | <error_message> |

  Examples:
    | volume      | error_message                                                         |
    |             | Enter number of tonnes                                                |
    | 0           | The number of tonnes must be a whole number between 1 and 999,999,999 |
    | 1000000000  | The number of tonnes must be a whole number between 1 and 999,999,999 |
    | 306.1       | The number of tonnes must be a whole number between 1 and 999,999,999 |
    | Pandoria    | The number of tonnes must be a whole number between 1 and 999,999,999 |

  Scenario Outline: Validating the volume for units
    Given I sign in and navigate to my account for 'RM3830'
    And I have a procurement in detailed search named 'Service volumes procurement' with the following services:
      | K.7 |
    And I navigate to the service requirements page
    And I choose to answer the service volume question for 'Feminine hygiene waste'
    Then I am on the page with secondary heading 'Feminine hygiene waste'
    Given I enter '<volume>' for the service volume
    And I click on 'Save and return'
    Then I should see the following error messages:
      | <error_message> |

  Examples:
    | volume      | error_message                                                         |
    |             | Enter number of units                                                 |
    | 0           | The number of units must be a whole number between 1 and 999,999,999  |
    | 1000000000  | The number of units must be a whole number between 1 and 999,999,999  |
    | 306.1       | The number of units must be a whole number between 1 and 999,999,999  |
    | Malos       | The number of units must be a whole number between 1 and 999,999,999  |