Feature: Internal and External area - validations

  Background: Navigate to Internal and external areas
    Given I sign in and navigate to my account for 'RM3830'
    And I have buildings
    And I click on 'Manage my buildings'
    Then I am on the 'Buildings' page
    And I click on 'Test building'
    Then I am on the 'Test building' page
    And I change the 'Gross internal area'
    Then I am on the 'Internal and external areas' page

  Scenario Outline: Areas are empty
    And I enter '' for the building 'GIA'
    And I enter '' for the building 'external area'
    And I click on '<save_button>'
    Then I should see the following error messages:
      | Internal area must be a number between 0 and 999,999,999  |
      | External area must be a number between 0 and 999,999,999  |

    Examples:
      | save_button                                   |
      | Save and continue                             |
      | Save and return to building details summary   |

  Scenario: Areas are not numbers
    And I enter 'hello' for the building 'GIA'
    And I enter 'hello' for the building 'external area'
    And I click on 'Save and continue'
    Then I should see the following error messages:
      | Gross Internal Area (GIA) must be a whole number  |
      | External area must be a whole number              |

  Scenario: Areas are not whole numbers
    And I enter '45.7' for the building 'GIA'
    And I enter '89.2' for the building 'external area'
    And I click on 'Save and continue'
    Then I should see the following error messages:
      | Enter a whole number for the size of internal area of this building |
      | Enter a whole number for the size of external area of this building |

  Scenario: Areas are greater than 999,999,999
    And I enter '1000000000' for the building 'GIA'
    And I enter '1000000000' for the building 'external area'
    And I click on 'Save and continue'
    Then I should see the following error messages:
      | Internal area must be a number between 0 and 999,999,999  |
      | External area must be a number between 0 and 999,999,999  |

  Scenario: Areas are both 0
    And I enter '0' for the building 'GIA'
    And I enter '0' for the building 'external area'
    And I click on 'Save and continue'
    Then I should see the following error messages:
      | Internal area must be greater than 0, if the external area is 0 |
      | External area must be greater than 0, if the internal area is 0 |
