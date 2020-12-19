include RSpec::Matchers
class SearchResultFlightPage < SitePrism::Page

    elements :schedule_choose_button,        ".v3-btn.v3-btn__yellow"
    elements :schedule_flight_name,          ".text-marketing-airline"
    elements :schedule_flight_time,          ".text-time"
    elements :schedule_flight_code,          ".text-code"
    elements :schedule_flight_price,         ".text-price-main-default"
    elements :schedule_flight_total_time, :xpath,   "//div[@class='list-horizontal__middle']/child::div[3]/child::div[@class='text-total-time']"
    elements :filter_list,                   ".custom-checkbox.single"
    element :coach_mark_ok_button,           ".btn-action"
    
    def choose_schedule(type)
        wait_until_schedule_choose_button_visible(wait: 15)
        set_schedule_data(type)
        schedule_choose_button[0].click
    end

    def set_schedule_data(type)
        if type.to_s == 'departure'
            $departure_flight_transit = schedule_flight_total_time[0].text
            $departure_flight_name = schedule_flight_name[0].text
            $departure_flight_origin_time = schedule_flight_time[0].text
            $departure_flight_destination_time = schedule_flight_time[1].text
            $departure_flight_origin_airport = schedule_flight_code[0].text
            $departure_flight_destination_airport = schedule_flight_code[1].text
            departure_normal_fare = (normalize_price(schedule_flight_price[0].text) * $totalAdultPassenger.to_i)
            departure_infant_fare = ((normalize_price(schedule_flight_price[0].text) * 0.1) * $totalInfantPassenger.to_i)
            $departure_flight_price = (departure_normal_fare.to_i + departure_infant_fare.to_i)

            puts "Departure flight name         : #{$departure_flight_name}"
            puts "Departure flight transit      : #{$departure_flight_transit}"
            puts "Departure flight airport code : #{$departure_flight_origin_airport} - #{$departure_flight_destination_airport}"
            puts "Departure flight time         : #{$departure_flight_origin_time} - #{$departure_flight_destination_time}"
            puts "Departure price               : #{$departure_flight_price}"
        else
            $return_flight_transit = schedule_flight_total_time[0].text
            $return_flight_name = schedule_flight_name[0].text
            $return_flight_origin_time = schedule_flight_time[0].text
            $return_flight_destination_time = schedule_flight_time[1].text
            $return_flight_origin_airport = schedule_flight_code[0].text
            $return_flight_destination_airport = schedule_flight_code[1].text
            return_normal_fare = (normalize_price(schedule_flight_price[0].text) * $totalAdultPassenger.to_i)
            return_infant_fare = ((normalize_price(schedule_flight_price[0].text) * 0.1) * $totalInfantPassenger.to_i)
            $return_flight_price = (return_normal_fare.to_i + return_infant_fare.to_i)

            puts "Return flight name         : #{$return_flight_name}"
            puts "Return flight transit      : #{$return_flight_transit}"
            puts "Return flight airport code : #{$return_flight_origin_airport} - #{$return_flight_destination_airport}"
            puts "Return flight time         : #{$return_flight_origin_time} - #{$return_flight_destination_time}"
            puts "Return price               : #{$return_flight_price}"
        end
    end

    def filter_schedule(type)
        filter_list(wait: 5)

        case type
        when 'langsug'
            filter_list[0].click
        when '1 transit'
            filter_list[1].click
        when '2 transit'
            filter_list[2].click
        end

        sleep 15 #load new schedule
    end

    def validate_class_filter(type)
        index = 0
        wait_until_schedule_choose_button_visible(wait: 5)

        while index < schedule_flight_total_time.length/2
            expect(schedule_flight_total_time[index].text).to eq(type)
            index += 1
        end
    end

end
