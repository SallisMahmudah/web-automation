include RSpec::Matchers
class CheckoutTrainPage < SitePrism::Page

    element :checkout_total_price,                        ".currency"
    element :checkout_payment_button,       :xpath,       "//div[@class='payment-button-next-step']/button"
    element :checkout_detail_invoice_button,              ".button.primary"

    def choose_payment_method(payment)
        find(:xpath, "//div[@class='method-type-name']/span", :text => payment).click
    end

    def validate_price()
        wait_until_checkout_total_price_visible(wait: 90)
        fee = $totalAdultPassenger.to_i * 7500

        total_amount = $total_price.to_i + fee.to_i
        expect(normalize_price(checkout_total_price.text)).to eq(total_amount)
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
