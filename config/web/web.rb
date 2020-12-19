# frozen_string_literal: true

require 'capybara'

# configuration for desktop and mobile web
browser = (ENV['BROWSER'] || 'chrome').to_sym
# user_agent = ENV['USER_AGENT'] || 'blstresstest'
wait_time = 60 * 5

puts "Browser   : #{browser}"
# puts "User Agent: #{user_agent}"

Capybara.register_driver :firefox do |app|
  profile = Selenium::WebDriver::Firefox::Profile.new
#   profile['general.useragent.override'] = user_agent
  options = Selenium::WebDriver::Firefox::Options.new
  options.add_preference 'dom.webdriver.enabled', false
  options.add_preference 'dom.webnotifications.enabled', false
  options.add_preference 'dom.push.enabled', false
  options.profile = profile
  client = Selenium::WebDriver::Remote::Http::Default.new
  client.open_timeout = wait_time
  client.read_timeout = wait_time
  Capybara::Selenium::Driver.new(
    app,
    browser: :firefox,
    options: options,
    http_client: client
  )
end

Capybara.register_driver :chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new
#   options.add_argument("--user-agent=#{user_agent}")
  options.add_argument('--no-sandbox')
  options.add_argument('--disable-dev-shm-usage')
  options.add_argument('--disable-notifications')
  options.add_argument('--window-size=1366,768')
  # handle basic auth
  options.add_argument('--disable-blink-features=BlockCredentialedSubresources')
  options.add_argument('--disable-blink-features=AutomationControlled')
  client = Selenium::WebDriver::Remote::Http::Default.new
  client.open_timeout = wait_time
  client.read_timeout = wait_time
  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome,
    options: options,
    http_client: client
  )
end

Capybara.register_driver :docker do |app|
  options = Selenium::WebDriver::Chrome::Options.new
#   options.add_argument("--user-agent=#{user_agent}")
  options.add_argument('--no-sandbox')
  options.add_argument('--disable-dev-shm-usage')
  options.add_argument('--disable-notifications')
  options.add_argument('--disable-extensions')
  options.add_argument('--disable-gpu')
  options.add_argument('--headless')
  options.add_argument('--window-size=1366,768')
  client = Selenium::WebDriver::Remote::Http::Default.new
  client.open_timeout = wait_time
  client.read_timeout = wait_time
  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome,
    options: options,
    http_client: client
  )
end

Capybara.register_driver :remote_browser do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  remote_browser_url = ENV['REMOTE_BROWSER_URL']
#   options.add_argument("--user-agent=#{user_agent}")
  options.add_argument('--no-sandbox')
  options.add_argument('--disable-dev-shm-usage')
  options.add_argument('--disable-notifications')
  options.add_argument('--window-size=1366,768')
  # handle basic auth
  options.add_argument('--disable-blink-features=BlockCredentialedSubresources')
  options.add_argument('--disable-blink-features=AutomationControlled')
  client = Selenium::WebDriver::Remote::Http::Default.new
  client.open_timeout = wait_time
  client.read_timeout = wait_time
  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome,
    options: options,
    url: remote_browser_url,
    http_client: client
  )
end

Capybara.configure do |config|
  config.default_max_wait_time = 20
end

Capybara::Screenshot.register_driver(browser) do |driver, path|
  driver.browser.save_screenshot path
end

Capybara.default_driver = browser

Capybara::Screenshot.autosave_on_failure = false

Capybara::Screenshot.prune_strategy = { keep: 50 }
Capybara::Screenshot.append_timestamp = true
