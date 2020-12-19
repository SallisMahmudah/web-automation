include RSpec::Matchers
class BookingFormFlightPage < SitePrism::Page

    elements :booking_fullname_field,                         ".input-list-autocomplete"
    elements :booking_title_dropdown,                         ".input-flight-dropdown"
    elements :booking_dropdown_list,                   :xpath,"//ul[@class='ul-list-menu']/li/div[@class='list-horizontal__middle']"
    elements :booking_summary_schedule_text,           :xpath,"//div[@class='flight-item-schedule']/div[@class='list-horizontal__middle']"
    elements :booking_country_dropdown,                       ".flight-dropdown-searchbox"
    elements :booking_confirmation_transaction_button, :xpath,"//div[@class='btn-notif']/button"
    elements :booking_adult_form,                      :xpath,"//*[contains (@id, 'adult-form')]"
    elements :booking_infant_form,                     :xpath,"//*[contains (@id, 'infant-form')]"
    elements :booking_detail_passenger_info,                  ".heading-passenger-details"
    element :booking_phone_number_field,               :xpath,"//input[@name='cp-phone']"
    element :booking_email_field,                      :xpath,"//input[@name='cp-email']"
    element :booking_total_price_text,                        ".total-payment-amount"
    element :booking_continue_transaction_button,             ".v3-btn.v3-btn__yellow.pull-right"
  
    def fill_buyer_data()
        name = faker_fullname
        phone = faker_phone_number('0881')
        email = faker_email
        elm = "//ul[@class='ul-list-menu']/li/div[@class='list-horizontal__middle']"

        puts "Buyer name  : #{name}"
        puts "Buyer Phone : #{phone}"
        puts "Buyer email : #{email}"

        booking_title_dropdown[0].click
        find(:xpath, elm, :text => faker_title).click
        booking_fullname_field[0].send_keys(name)
        booking_email_field.send_keys(email)
        booking_phone_number_field.send_keys(phone)
    end

    def validate_schedule_data()
        if $route == 'round trip'
            expect(booking_summary_schedule_text[3].text).to eq("#{$return_flight_origin_airport} - #{$return_flight_destination_airport}")
            expect(booking_summary_schedule_text[5].text).to eq("#{$return_flight_origin_time}")
        else
            expect(booking_summary_schedule_text[0].text).to eq("#{$departure_flight_origin_airport} - #{$departure_flight_destination_airport}")
            expect(booking_summary_schedule_text[2].text).to eq("#{$departure_flight_origin_time}")
        end

        $total_price = $departure_flight_price.to_i + $return_flight_price.to_i
        expect(normalize_price(booking_total_price_text.text)).to eq($total_price)
    end

    def fill_passenger_data()
        index = 1
        totalPassengers = booking_detail_passenger_info.length + 1
        totalInfant = ((booking_infant_form.length) + 1).to_i
        elm = "//ul[@class='ul-list-menu']/li/div[@class='list-horizontal__middle']"

        loop do
            booking_title_dropdown[index].click
            find(:xpath, elm, :text => faker_title).click
            booking_fullname_field[index].send_keys(faker_fullname)
            booking_country_dropdown[index].click
            find(:xpath, elm, :text => ENV['FLIGHT_CITIZENSHIP']).click
            index += 1
            break if index == totalPassengers
        end
        
        if totalInfant > 1
            loop do
                booking_fullname_field[index].send_keys(faker_fullname)
                booking_born_date_field[index - 1].send_keys('3')
                booking_born_month_field[index - 1].send_keys('Feb')
                booking_born_year_field[index - 1].send_keys('2018')
                index += 1
                break if index == totalInfant
            end
        end
    end

    def tap_continue_transaction_button()
        booking_continue_transaction_button.click
        tap_yes_on_confirmation_button
    end

    def tap_yes_on_confirmation_button()
        booking_confirmation_transaction_button(wait: 3)
        booking_confirmation_transaction_button[1].click
    end
end
