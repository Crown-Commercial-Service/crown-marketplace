Feature: Continueing from Further service and contract requirements - validations

  Background: Sign in
    Given I sign in and navigate to my account for 'RM6232'

  Scenario: When nothing is completed
    Given I have an empty procurement for entering requirements named 'My empty procurement'
    When I navigate to the procurement 'My empty procurement'
    Then I am on the 'Further service and contract requirements' page
    And I click on 'Save and continue'
    Then I should see the following error messages:
      | ‘TUPE’ must be ‘COMPLETED’                            |
      | ‘Contract period’ must be ‘COMPLETED’                 |
      | ‘Buildings’ must be ‘COMPLETED’                       |
      | ‘Assigning services to buildings’ must be ‘COMPLETED’ |

  Scenario: When the initial call off period is in the past
    Given I have a completed procurement for entering requirements named 'My completed procurement' with an initial call off period in the past
    When I navigate to the procurement 'My completed procurement'
    Then I am on the 'Further service and contract requirements' page
    And everything is completed
    And I click on 'Save and continue'
    Then I should see the following error messages:
      | Initial call-off period start date must not be in the past  |

  Scenario: When the mobilisation period is in the past
    Given I have a completed procurement for entering requirements named 'My completed procurement' with an mobilisation period in the past
    When I navigate to the procurement 'My completed procurement'
    Then I am on the 'Further service and contract requirements' page
    And everything is completed
    And I click on 'Save and continue'
    Then I should see the following error messages:
      | Mobilisation period start date must not be in the past  |

  Scenario: When the mobilisation period is not 4 weeks with tupe selected
    Given I have a completed procurement for entering requirements named 'My completed procurement' with mobilisation less than four weeks
    When I navigate to the procurement 'My completed procurement'
    Then I am on the 'Further service and contract requirements' page
    And everything is completed
    And I click on 'Save and continue'
    Then I should see the following error messages:
      | Mobilisation period length must be a minimum of 4 weeks when TUPE is selected |