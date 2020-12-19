  
  When(/^user fill in the (.*) booking form with (valid|invalid) data$/) do |product, flag|
    case product.downcase
    when 'train'
        @booking = BookingFormTrainPage.new
        @booking.booking_total_price_text(wait: 5)

         if flag.to_s == 'valid'
            @booking.fill_buyer_data
            @booking.validate_schedule_data
            @booking.fill_passenger_data
            @booking.choose_seat
            @booking.tap_continue_transaction_button
         end
    when 'flight'
        @booking = BookingFormFlightPage.new
        @booking.booking_total_price_text(wait: 5)

         if flag.to_s == 'valid'
            @booking.fill_buyer_data
            @booking.validate_schedule_data
            @booking.fill_passenger_data
            @booking.tap_continue_transaction_button
         end
    end
  end

  And(/^user chooses "([^"]*)" payment to continue the "([^"]*)" transaction$/) do |payment, product|
    case product.downcase
    when 'train'
        @checkout = CheckoutTrainPage.new
        @checkout.validate_price
        @checkout.choose_payment_method(payment.to_s)
        @checkout.tap_on_payment_button
        @checkout.validate_price
    when 'flight'
        @checkout = CheckoutFlightPage.new
        @checkout.validate_price
        @checkout.validate_schedule
        @checkout.choose_payment_method(payment.to_s)
        @checkout.tap_on_payment_button
        @checkout.validate_price
    end
  end

  And(/^user navigates to invoice details "([^"]*)" transaction$/) do |product|
    case product.downcase
    when 'train'
        @detail = CheckoutTrainPage.new
        @detail.tap_on_invoice_detail_button
        @detail.validate_price
    when 'flight'
        @detail = CheckoutFlightPage.new
        @detail.tap_on_invoice_detail_button
    end        
  end
