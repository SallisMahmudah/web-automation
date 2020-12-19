include RSpec::Matchers
class BookingFormTrainPage < SitePrism::Page

    elements :booking_fullname_field,           :xpath,   "//*[@name='fullName']"
    elements :booking_title_dropdown,                     ".form-row.title"
    elements :booking_identity_number_field,    :xpath,   "//*[@name='identityNumber']"
    elements :booking_born_date_section,                  ".input-date"
    elements :booking_born_date_field,          :xpath,   "//div[contains(@class,'autocomplete-list autocomplete-date')]/div[@class='option-list']"
    elements :booking_born_month_field,         :xpath,   "//div[contains(@class,'autocomplete-list autocomplete-month')]/div[@class='option-list']"
    elements :booking_born_year_field,          :xpath,   "//div[contains(@class,'autocomplete-list autocomplete-year')]/div[@class='option-list']"
    elements :booking_summary_schedule_text,              ".summary-text"
    elements :booking_seat_available,                     ".seat.false"
    elements :booking_confirmation_transaction_button, :xpath, "//div[@class='button-area']/button"
    elements :booking_adult_form,               :xpath,   "//*[contains (@id, 'adult-form')]"
    elements :booking_infant_form,               :xpath,  "//*[contains (@id, 'infant-form')]"
    elements :booking_title_dropdown_list,       :xpath,  "//div[contains(@class,'autocomplete-list')]/div[@class='option-list']"
    element :booking_phone_number_field,        :xpath,   "//*[@name='phone']"
    element :booking_email_field,               :xpath,   "//*[@name='emailAddress']"
    element :booking_form_switch_button,                  ".form-switch-btn"
    element :booking_total_price_text,          :xpath,   "//div[@class='pull-right text-price']"
    element :booking_choose_seat_button,                  ".btn-choose-seat"
    element :booking_continue_transaction_button, :xpath, "//div[@class='action-area']/button"
     
    def fill_buyer_data()
        name = faker_fullname
        phone = faker_phone_number('0881')
        email = faker_email

        puts "Buyer name  : #{name}"
        puts "Buyer Phone : #{phone}"
        puts "Buyer email : #{email}"

        booking_fullname_field[0].send_keys(name)
        booking_phone_number_field.send_keys(phone)
        booking_email_field.send_keys(email)
    end

    def validate_schedule_data()
        expect(booking_summary_schedule_text[0].text).to eq("#{$departure_train_origin_station} - #{$departure_train_destination_station}")
        expect(booking_summary_schedule_text[2].text).to eq("#{$departure_train_origin_time}")

        if $route == 'round trip'
            expect(booking_summary_schedule_text[0].text).to eq("#{$return_train_origin_station} - #{$return_train_destination_station}")
            expect(booking_summary_schedule_text[2].text).to eq("#{$return_train_origin_time}")
        end

        $total_price = $departure_train_price.to_i + $return_train_price.to_i
        expect(normalize_price(booking_total_price_text.text)).to eq($total_price)
    end

    def fill_passenger_data()
        index = 1
        totalAdult = ((booking_adult_form.length) + 1).to_i
        totalInfant = booking_infant_form.length.to_i
        date = "//div[contains(@class,'autocomplete-list autocomplete-date')]/div[@class='option-list']"
        month = "//div[contains(@class,'autocomplete-list autocomplete-month')]/div[@class='option-list']"

        loop do
            booking_fullname_field[index].send_keys(faker_fullname)
            booking_identity_number_field[index - 1].send_keys(faker_identity_number)
            index += 1
            break if index == totalAdult
        end
        
        if totalInfant > 0
            index = 0
            loop do
                booking_fullname_field[totalAdult].send_keys(faker_fullname)
                booking_born_date_section[index].click
                sleep 1
                find(:xpath, date, text: faker_date, match: :first).click
                sleep 1
                find(:xpath, month, text: faker_month, match: :first).click
                sleep 1
                booking_born_year_field[3].click
                index += 1
                totalAdult += 1
                break if index == totalInfant
            end
        end
    end

    def tap_seat_button()
        booking_choose_seat_button.click
    end

    def choose_seat()
        tap_seat_button
        sleep 3
        booking_seat_available[2].click
    end

    def tap_continue_transaction_button()
        booking_continue_transaction_button.click
        tap_yes_on_confirmation_button
    end

    def tap_yes_on_confirmation_button()
        booking_confirmation_transaction_button(wait: 3)
        booking_confirmation_transaction_button[0].click
    end
end
