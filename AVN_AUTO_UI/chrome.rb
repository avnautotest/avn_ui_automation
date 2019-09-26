require 'selenium-webdriver'
require 'rspec/expectations'
require 'faraday'
require 'date'
include RSpec::Matchers

def setup
  Selenium::WebDriver::Chrome::Service.driver_path = "/Applications/chromedriver"
  @driver = Selenium::WebDriver.for :chrome
end

def teardown
  @driver.quit
end

def run
  setup
  yield
  teardown
end

conn = Faraday.new(:url => 'https://avn2.retloko.com') do |faraday|
    faraday.request  :url_encoded             # form-encode POST params
    faraday.response :logger                  # log requests to $stdout
    faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
  end

run do
    date = DateTime.new
    time = date.strftime("%Y%m%dT%H%M")
    email = ('retlokoautoapi+' + time + '@gmail.com')
    print(email)
    password = 'P@55w0rd'
    name = 'tech'
    conn.post '/api2/v2/users/register', { :email => email, :password => password, :name => name }
    @driver.get 'https://avn2.retloko.com'
    @driver.find_element_by_css_selector('.btn.login').click
    #expect(@driver.title).to eql 'The Internet'

  end
