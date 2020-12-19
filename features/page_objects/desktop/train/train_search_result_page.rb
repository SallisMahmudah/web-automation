include RSpec::Matchers
class SearchResultTrainPage < SitePrism::Page

    elements :schedule_choose_button,       ".v3-btn.v3-btn-yellow.tiny-button"
    elements :schedule_train_class,         ".text-train-class"
    elements :schedule_train_name,          ".text-train-name"
    elements :schedule_train_time,          ".text-time"
    elements :schedule_train_station,       ".text-station"
    elements :schedule_train_price,       ".text-price"
    elements :filter_list,       ".custom-checkbox.single"
    element :filter_executive_check_box, :xpath, "//input[@name='Eksekutif']"
    element :filter_ekonomi_check_box, :xpath, "//input[@name='Ekonomi']"
    
    def choose_schedule(type)
        wait_until_schedule_choose_button_visible(wait: 15)
        set_schedule_data(type)
        schedule_choose_button[0].click
    end

    def set_schedule_data(type)
        if type.to_s == 'departure'
            $departure_train_class = schedule_train_class[0].text
            $departure_train_name = schedule_train_name[0].text
            $departure_train_origin_time = schedule_train_time[0].text
            $departure_train_destination_time = schedule_train_time[1].text
            $departure_train_origin_station = schedule_train_station[0].text
            $departure_train_destination_station = schedule_train_station[1].text
            $departure_train_price = (normalize_price(schedule_train_price[0].text) * $totalAdultPassenger.to_i)

            puts "Departure train name      : #{$departure_train_name}"
            puts "Departure train class     : #{$departure_train_class}"
            puts "Departure train stations  : #{$departure_train_origin_station} - #{$departure_train_destination_station}"
            puts "Departure train time      : #{$departure_train_origin_time} - #{$departure_train_destination_time}"
            puts "Departure price           : #{$departure_train_price}"
        else
            $return_train_class = schedule_train_class[0].text
            $return_train_name = schedule_train_name[0].text
            $return_train_origin_time = schedule_train_time[0].text
            $return_train_destination_time = schedule_train_time[1].text
            $return_train_origin_station = schedule_train_station[0].text
            $return_train_destination_station = schedule_train_station[1].text
            $return_train_price = (normalize_price(schedule_train_price[0].text) * $totalAdultPassenger.to_i)

            puts "Return train name      : #{$return_train_name}"
            puts "Return train class     : #{$return_train_class}"
            puts "Return train stations  : #{$return_train_origin_station} - #{$return_train_destination_time}"
            puts "Return train time      : #{$return_train_origin_time} - #{$return_train_destination_time}"
            puts "Return price           : #{$return_train_price}"
        end
    end

    def filter_schedule(type)
        filter_list(wait: 5)

        case type.downcase
        when 'eksekutif'
            filter_list[2].click
        when 'ekonomi'
            filter_list[0].click
        end
    end

    def validate_class_filter(type)
        index = 0
        schedule_choose_button(wait: 5)

        while index < schedule_train_class.length
            expect(schedule_train_class[index]).to have_text(type)
            index += 1
        end
    end
end
