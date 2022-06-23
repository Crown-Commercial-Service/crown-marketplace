Feature: Further information

  Background: I navigate to the Entering requirements page
    Given I sign in and navigate to my account for 'RM6232'
    Given I have a completed procurement for further information named 'My completed procurement'
    When I navigate to the procurement 'My completed procurement'
    And I am on the 'What do I do next?' page

  Scenario: The content is correct
    And the procurement name is shown to be 'My completed procurement'
    Then the following content should be displayed on the page:
      | Step 1 - Download your results                                                    |
      | We have used the information entered on the previous pages to prepopulate a       |
      | deliverables matrix and a supplier bief which                                     |
      | you can use when running your further competition.                                |
      | Step 2 - Review the Facilities Management framework page                          |
      | On the facilities management framework page, you can view information including:  |

  # TODO: Add when the documents ahve been created
  # @pipeline
  # Scenario: I can download the deliverables matrix
  #   And I click on "Prepopulated 'Deliverables matrix'"
  #   Then the spreadsheet 'Deliverables Matrix (My completed procurement)' is downloaded

  # @pipeline
  # Scenario: I can download the supplier bried
  #   And I click on "Prepopulated 'Supplier brief'"
  #   Then the spreadsheet 'Supplier brief (My completed procurement)' is downloaded

  Scenario: Back button link
    And I click on 'Return to procurements dashboard'
    Then I am on the 'Saved searches' page

  Scenario: Return link
    And I click on 'Return to your account'
    And I am on the Your account page
