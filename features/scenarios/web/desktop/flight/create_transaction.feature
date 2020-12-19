@flight @web-automation
Feature: Flight Ticket Create Transaction

  Scenario: User create flight ticket transaction with non instant payment
    Given user go to flight page
    And user search "round trip" flight schedule from landing page
    And the passengers is 1 adult 0 child and 0 infant
    And user select "round trip" journey with filter "1 Transit"
    And user fill in the flight booking form with valid data
    When user chooses "BCA Virtual Account" payment to continue the "flight" transaction
    Then user navigates to invoice details "flight" transaction
