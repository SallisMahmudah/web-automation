  And(/^user go to train page$/) do
    @search = SearchTrainPage.new
    @search.load
    sleep 3
    @search.coach_mark_ok_button_kereta_bandara.click
  end
  
  When(/^search "([^"]*)" train from landing page$/) do |route|
    @search = SearchTrainPage.new
    @search.choose_origin_station
    @search.choose_destination_station
    @search.choose_date('departure')

    if route.downcase.to_s == 'round trip'
      @search.choose_date('return')
    end
  end

  And(/^the passengers is (.*) adult and (.*) infant$/) do |adult, infant|
    @search = SearchTrainPage.new
    @search.choose_passenger('adult', adult.to_i)
    @search.choose_passenger('infant', infant.to_i)
    @search.passenger_picker_selesai_button.click
    @search.search_schedule
    $totalAdultPassenger = adult
  end

  When(/^user select "([^"]*)" journey with "([^"]*)" train class$/) do |route, type|
    @result = SearchResultTrainPage.new
    $route = route.downcase.to_s
    @result.filter_schedule(type.downcase)
    @result.validate_class_filter(type)
    @result.choose_schedule('departure')

    if route.downcase.to_s == 'round trip'
      @result.choose_schedule('return')
    end
  end

  When(/^user fill in the booking form with (valid|invalid) data$/) do |flag|
    @booking = BookingFormTrainPage.new
    @booking.booking_total_price_text(wait: 5)

    if flag.to_s == 'valid'
      @booking.fill_buyer_data
      @booking.validate_schedule_data
      @booking.fill_passenger_data
      @booking.choose_seat
      @booking.tap_continue_transaction_button
    end
  end
