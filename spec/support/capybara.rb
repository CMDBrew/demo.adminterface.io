require "rack_session_access/capybara" # Access to rack session
require "fileutils"
require "webdrivers"

Capybara.register_driver(:chrome) do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument "--window-size=1024,768"
  options.add_argument "--no-sandbox"

  unless ENV["SPEC_LIVE_BROWSING"].eql?("true")
    options.add_argument "--headless"
    options.add_argument "--disable-gpu"
  end
  Capybara::Selenium::Driver.new(app, browser: :chrome, native_displayed: false, options: options)
end

Capybara.javascript_driver = :webkit
Capybara.default_driver = :chrome
Capybara.default_max_wait_time = 5
