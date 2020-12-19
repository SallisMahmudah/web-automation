include RSpec::Matchers
class SearchTrainPage < SitePrism::Page
    path = "/kereta-api"
    set_url(ENV['BASE_URL']+path)

    element :coach_mark_ok_button_kereta_bandara,   ".v3-btn.v3-btn-blue"
    element :input_origin_station,      :xpath,     "//*[@placeholder='Kota atau stasiun']"
    element :input_destination_station, :xpath,     "//*[@placeholder='Mau ke mana?']"
    element :origin_station_list,       :xpath,     "//*[@data-cityname='Bandung'][1]"
    element :destination_station_list,  :xpath,     ".//*[@data-cityname='Jakarta'][1]"
    element :date_picker_close_button,              ".btn-close"
    element :search_schedule_button,    :xpath,     "//div[@class='footer-part']/button"
    element :round_trip_check_box,                  ".check"
    element :return_date_picker,                    ".wrapper-datepicker.datepicker-return"
    elements :passenger_picker_increase, :xpath,    "//i[contains(@class, 'tix-plus icon')]"
    elements :passenger_picker_count,   :xpath,     "//i[contains(@class, 'tix-plus icon')]/parent::*/parent::*/preceding-sibling::div[contains(@class, 'counter')]"
    element :passenger_picker_selesai_button, :xpath, "//div[@class='foot']/button"

    def choose_origin_station()
        input_origin_station.click
        origin_station_list(wait: 60)
        origin_station_list.click
    end

    def choose_destination_station()
        input_destination_station.click
        destination_station_list(wait: 60)
        destination_station_list.click
    end

    def choose_date(type)
        next_day = Date.today.to_s.split('-').last.to_i + 2
        date_text = next_day > 30 ? 5 : next_day

        if type.to_s == 'return'
            round_trip_check_box.click
            return_date_picker.click
            date_text += 2
        end

        date_picker = "//td[contains(@class,'CalendarDay CalendarDay_1 CalendarDay__default')"\
                      " and not(contains(@class, 'CalendarDay__selected'))]/div"

        find(:xpath, date_picker, text: date_text, match: :first).click
    end

    def choose_passenger(type, count)
        index = type.to_s == 'adult' ? 0 : 1
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
