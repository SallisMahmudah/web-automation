include RSpec::Matchers
class BookingFormFlightPage < SitePrism::Page

    elements :booking_fullname_field,                         ".input-list-autocomplete"
    elements :booking_general_dropdown,                       ".input-flight-dropdown"
    elements :booking_title_dropdown,                  :xpath,"//div[contains(@class,'title-dropdown')]/div[@class='title-flight-dropdown']"
    elements :booking_dropdown_list,                   :xpath,"//ul[@class='ul-list-menu']/li/div[@class='list-horizontal__middle']"
    elements :booking_summary_schedule_text,           :xpath,"//div[@class='flight-item-schedule']/div[@class='list-horizontal__middle']"
    elements :booking_country_dropdown,                       ".flight-dropdown-searchbox"
    elements :booking_confirmation_transaction_button, :xpath,"//div[@class='btn-notif']/button"
    elements :booking_adult_form,                      :xpath,"//*[contains (@id, 'adult-form')]"
    elements :booking_infant_form,                     :xpath,"//*[contains (@id, 'infant-form')]"
    elements :booking_detail_passenger_info,                  ".heading-passenger-details"
    elements :booking_birth_date_field,                       ".wrapper-date-split"
    elements :booking_born_year_field,                 :xpath,"//ul[@class='ul-list-menu']/li"
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

        booking_general_dropdown.first.click
        find(:xpath, elm, :text => faker_title).click
        booking_fullname_field.first.send_keys(name)
        booking_email_field.send_keys(email)
        booking_phone_number_field.send_keys(phone)
    end

    def validate_schedule_data()
        wait_until_booking_total_price_text_visible(wait: 60)

        if $route == 'round trip'
            expect(booking_summary_schedule_text[3].text).to eq("#{$return_flight_origin_airport} - #{$return_flight_destination_airport}")
            expect(booking_summary_schedule_text[5].text).to eq("#{$return_flight_origin_time}")
        else
            expect(booking_summary_schedule_text[0].text).to eq("#{$departure_flight_origin_airport} - #{$departure_flight_destination_airport}")
            expect(booking_summary_schedule_text[2].text).to eq("#{$departure_flight_origin_time}")
        end

        $total_price = normalize_price(booking_total_price_text.text)
    end

    def fill_passenger_data()
        count = 1
        totalPassengers = booking_detail_passenger_info.length + 1
        elm = "//ul[@class='ul-list-menu']/li/div[@class='list-horizontal__middle']"

        loop do
            booking_title_dropdown.first.click
            find(:xpath, elm, :text => faker_title).click
            booking_fullname_field[count].send_keys(faker_fullname)
            booking_country_dropdown[count].click
            find(:xpath, elm, :text => ENV['FLIGHT_CITIZENSHIP']).click
            count += 1
            break if count == totalPassengers
        end
        
        if page.has_css?('.wrapper-date-split')
            birthDateCount = booking_birth_date_field.length
            count = 0
            
            loop do 
                booking_birth_date_field[count].click
                sleep 1
                find(:xpath, elm, text: faker_date, match: :first).click
                sleep 1
                find(:xpath, elm, text: faker_month, match: :first).click
                sleep 1
                booking_born_year_field[1].click
                count += 1
                break if count == birthDateCount
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
