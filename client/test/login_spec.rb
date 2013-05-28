# require 'spec_helper'
require 'selenium-webdriver'

describe 'when a user is not authenticated' do
  it 'should redirect to the login page' do
    driver = Selenium::WebDriver.for :android
    driver.get "http://192.168.1.114:3000/#"
    wait = Selenium::WebDriver::Wait.new(:timeout => 10)
    wait.until { driver.find_element :id, "password" }
    driver.current_url.should == 'http://192.168.1.114:3000/#login'
    driver.quit
  end

  it 'should allow a user to login and redirect to the home page' do
    driver = Selenium::WebDriver.for :android
    driver.get "http://192.168.1.114:3000/#login"
    driver.find_element(:id, 'username').send_keys "ue@test.com"
    driver.find_element(:id, 'password').send_keys "Password"
    submit_button = driver.find_element(:class, "sign-in").click
    wait = Selenium::WebDriver::Wait.new(:timeout => 60)
    wait.until { driver.find_element :id, 'home-view' }
    driver.current_url.should == 'http://192.168.1.114:3000/#'
    driver.quit
  end
end
