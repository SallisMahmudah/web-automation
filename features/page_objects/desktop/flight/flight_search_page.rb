include RSpec::Matchers
class SearchFlightPage < SitePrism::Page
    path = "/pesawat"
    set_url(ENV['BASE_URL']+path)

    elements :input_airport,                            ".input-airport"
    elements :round_trip_check_box,                     ".check"
    elements :airport_list,                             ".col-code"
    elements :passenger_picker_increase,    :xpath,     "//i[contains(@class, 'tix-plus')]"
    elements :passenger_picker_count,       :xpath,     "//div[@class='list-horizontal__middle']/span"
    element :roundtrip_radio_button,        :xpath,     "//input[@id='roundtrip']"
    element :return_date_picker,                        ".datepicker-flightform-return"
    element :passenger_picker_selesai_button,           ".btn-done"
    element :search_schedule_button,                    ".v3-btn__yellow"

    def tap_round_trip_radio_button()
        roundtrip_radio_button.click
    end
    
    def choose_origin_airport()
        input_airport[0].click
        wait_until_airport_list_visible(wait: 3)
        find('.col-code', :text => ENV['ORIGIN_AIRPORT_CODE']).click
    end

    def choose_destination_airport()
        input_airport[1].click
        wait_until_airport_list_visible(wait: 3)
        find('.col-code', :text => ENV['DESTINATION_AIRPORT_CODE']).click
    end

    def choose_date(type)
        next_day = Date.today.to_s.split('-').last.to_i + 2
        date_text = next_day > 30 ? 5 : next_day

        if type.to_s == 'return'
            round_trip_check_box[0].click
            date_text += 2
        end

        date_picker = "//td[contains(@class,'CalendarDay CalendarDay_1 CalendarDay__default')"\
                      " and not(contains(@class, 'CalendarDay__selected'))]/div"

        find(:xpath, date_picker, text: date_text, match: :first).click
    end

    def choose_passenger(type, count)
        case type.downcase
        when 'adult'
            index = 0
        when 'child'
            index = 1
        when 'infant'
            index = 2
        end
        
        total = (passenger_picker_count[index].text).to_i
        
        while total < count
            passenger_picker_increase[index].click
            total += 1
        end

        expect(total).to eq(count)
    end

    def search_schedule()
        search_schedule_button.click
    end
end
