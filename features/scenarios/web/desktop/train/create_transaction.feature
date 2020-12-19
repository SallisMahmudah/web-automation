@train @web-automation
Feature: Train Ticket Create Transaction

  Scenario: User create train ticket transaction with non instant payment
    Given user go to train page
    And search "one way" train from landing page
    And the passengers is 1 adult and 0 infant
    And user select "one way" journey with "Eksekutif" train class
    And user fill in the train booking form with valid data
    When user chooses "Indomaret" payment to continue the "train" transaction
    Then user navigates to invoice details "train" transaction
