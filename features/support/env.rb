$LOAD_PATH.unshift File.expand_path('../../page_objects/desktop', __FILE__)

require 'securerandom'
require "capybara/cucumber"
require "capybara-screenshot/cucumber"
require "capybara/rspec"
require 'faker'
require "selenium-webdriver"
require "rspec/retry"
require 'rspec/expectations'
require "dotenv"
require "site_prism"
require "httparty"
require "uri"
require "net/http"
require "headless"
require "nokogiri"
require "open-uri"
require "filesize"
require "fileutils"
require "net/http/post/multipart"
require "logger"
require "uri"
require "net/ssh"
require 'browsermob/proxy'
require 'logger'
require 'webdrivers'


Dotenv.load
Dotenv.overload(".env.#{ENV['ENV']}")
