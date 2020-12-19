And(/^user go to flight page$/) do
    @search = SearchFlightPage.new
    @search.load
    sleep 3
  end
  
  When(/^user search "([^"]*)" flight schedule from landing page$/) do |route|
    @search = SearchFlightPage.new
    @search.choose_origin_airport
    @search.choose_destination_airport
    @search.choose_date('departure')

    if route.downcase.to_s == 'round trip'
      @search.choose_date('return')
    end
  end

  And(/^the passengers is (.*) adult (.*) child and (.*) infant$/) do |adult, child, infant|
    @search = SearchFlightPage.new
    @search.choose_passenger('adult', adult.to_i)
    @search.choose_passenger('child', child.to_i)
    @search.choose_passenger('infant', infant.to_i)
    @search.passenger_picker_selesai_button.click
    @search.search_schedule
    $totalAdultPassenger = adult.to_i + child.to_i
    $totalInfantPassenger = infant.to_i
  end

  When(/^user select "([^"]*)" journey with filter "([^"]*)"$/) do |route, filter|
    @result = SearchResultFlightPage.new
    $route = route.downcase.to_s
    @result.coach_mark_ok_button.click
    @result.filter_schedule(filter.downcase)
    @result.validate_class_filter(filter)
    @result.choose_schedule('departure')

    if route.downcase.to_s == 'round trip'
      @result.choose_schedule('return')
    end
  end
