include RSpec::Matchers
class CheckoutFlightPage < SitePrism::Page

    elements :checkout_schedule_detail_section,     :xpath, "//*[contains(@class,'order-info-header')]"
    elements :checkout_schedule_airport_code_text,  :xpath, "//div[@class='order-detail-flight']/div/div/strong"
    elements :checkout_schedule_detail_text,        :xpath, "//div[@class='card-body']/div/ul/li/strong"
    elements :checkout_detail_tab,                  :xpath, "//ul[@class='order-detail-tab']/li"
    element :checkout_total_price,                          ".currency"
    element :checkout_payment_button,               :xpath, "//div[@class='payment-button-next-step']/button"
    element :checkout_detail_invoice_button,                ".button.primary"
    

    def choose_payment_method(payment)
        find(:xpath, "//div[@class='method-type-name']/span", :text => payment).click
    end

    def validate_schedule()
        wait_until_checkout_schedule_detail_section_visible(wait: 30)
        checkout_schedule_detail_section[0].click

        if $route == 'round trip'
            checkout_detail_tab[1].click
            expect(checkout_schedule_airport_code_text[0].text).to eq("#{$return_flight_origin_airport}")
            expect(checkout_schedule_airport_code_text[1].text).to eq("#{$return_flight_destination_airport}")
            expect(checkout_schedule_detail_text.first.text).to eq("#{$return_flight_origin_time}")
        else
            expect(checkout_schedule_airport_code_text[0].text).to eq("#{$departure_flight_origin_airport}")
            expect(checkout_schedule_airport_code_text[1].text).to eq("#{$departure_flight_destination_airport}")
            expect(checkout_schedule_detail_text.first.text).to eq("#{$departure_flight_origin_time}")
        end

        checkout_schedule_detail_section[0].click
    end

    def validate_price()
        wait_until_checkout_schedule_detail_section_visible(wait: 90)

        totalAmount = $total_price.to_i + 7500
        expect(normalize_price(checkout_total_price.text)).to eq(totalAmount)
    end

    def tap_on_payment_button()
        wait_until_checkout_payment_button_visible(wait: 5)
        checkout_payment_button.click
    end

    def tap_on_invoice_detail_button()
        wait_until_checkout_detail_invoice_button_visible(wait: 5)
        checkout_detail_invoice_button.click
    end
end
