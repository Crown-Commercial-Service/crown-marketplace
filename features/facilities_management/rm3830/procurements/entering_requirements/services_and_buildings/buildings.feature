Feature: Buildings

  Background: Navigate to the requirements page
    Given I sign in and navigate to my account for 'RM3830'
    And I have an empty procurement for entering requirements named 'My buildings procurement'
    When I navigate to the procurement 'My buildings procurement'
    Then I am on the 'Requirements' page

  Scenario: Building selection saves
    Given I have buildings
    And I click on 'Buildings'
    Then I am on the 'Buildings' page
    And I find and select the following buildings:
      | Test building         |
      | Test London building  |
    And I click on 'Save and return'
    Then I am on the 'Buildings summary' page
    And the summary should say 2 buildings selected
    And I should see the following seleceted buildings in the summary:
      | Test building         |
      | Test London building  |
    And I click on 'Return to requirements'
    Then I am on the 'Requirements' page
    And 'Buildings' should have the status 'COMPLETED' in 'Services and buildings'
    When I click on 'Buildings'
    Then I am on the 'Buildings summary' page

  Scenario: Incomplete buildings cannot be selected
    Given I have buildings
    And I have incomplete buildings
    And I click on 'Buildings'
    And I am on the 'Buildings' page
    Then the following buildings cannot be selected:
      | Test incomplete building        |
      | Test incomplete London building |
    And the following buildings can be selected:
      | Test building         |
      | Test London building  |

  Scenario: Selections and deselections carry over between pages - no saved buildings
    Given I have 200 buildings
    And I click on 'Buildings'
    And I am on the 'Buildings' page
    And I find and select the following buildings:
      | Test building 015 |
      | Test building 067 |
      | Test building 080 |
    And I click on 'Next'
    And I am on the 'Buildings' page
    And I find and select the following buildings:
      | Test building 147 |
      | Test building 200 |
    And I click on 'Previous'
    And I am on the 'Buildings' page
    Then the following buildings are selected:
      | Test building 015 |
      | Test building 067 |
      | Test building 080 |
    And I deselect building 'Test building 067'
    And I click on 'Next'
    And I am on the 'Buildings' page
    Then the following buildings are selected:
      | Test building 147 |
      | Test building 200 |
    And I find and select the building with the name 'Test building 101'
    And I deselect building 'Test building 147'
    And I click on 'Previous'
    And I am on the 'Buildings' page
    Then the following buildings are selected:
      | Test building 015 |
      | Test building 080 |
    And I click on 'Next'
    And I am on the 'Buildings' page
    Then the following buildings are selected:
      | Test building 101 |
      | Test building 200 |
    And I click on 'Save and return'
    Then I am on the 'Buildings summary' page
    And the summary should say 4 buildings selected
    And I should see the following seleceted buildings in the summary:
      | Test building 015 |
      | Test building 080 |
      | Test building 101 |
      | Test building 200 |

  Scenario: Selections and deselections carry over between pages - with saved buildings
    Given I have 200 buildings
    And I click on 'Buildings'
    And I am on the 'Buildings' page
    And I find and select the building with the name 'Test building 001'
    And I click on 'Next'
    And I am on the 'Buildings' page
    And I find and select the building with the name 'Test building 101'
    And I click on 'Save and return'
    Then I am on the 'Buildings summary' page
    And the summary should say 2 buildings selected
    And I should see the following seleceted buildings in the summary:
      | Test building 001 |
      | Test building 101 |
    Then I click on 'Change'
    And I am on the 'Buildings' page
    Then the following buildings are selected:
      | Test building 001 |
    And I find and select the building with the name 'Test building 023'
    And I deselect building 'Test building 001'
    And I click on 'Next'
    And I am on the 'Buildings' page
    Then the following buildings are selected:
      | Test building 101 |
    And I deselect building 'Test building 101'
    And I click on 'Previous'
    And I am on the 'Buildings' page
    Then the following buildings are selected:
      | Test building 023 |
    And I click on 'Next'
    And I am on the 'Buildings' page
    And no buildings are selected
    Then I click on 'Save and return'
    Then I am on the 'Buildings summary' page
    And the summary should say 1 building selected
    And I should see the following seleceted buildings in the summary:
      | Test building 023 |

  Scenario: Text when there are no buildings
    And I click on 'Buildings'
    Then I am on the 'Buildings' page
    Given I click on the 'Return to requirements' return link
    Then I am on the 'Requirements' page
    And 'Buildings' should have the status 'NOT STARTED' in 'Services and buildings'
