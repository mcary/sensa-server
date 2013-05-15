require 'spec_helper'

describe "FeederController", :type => :feature do
  it "feeds" do
    serial = mock(:serial)
    SerialPort.stub(:new => serial)
    serial.should_receive(:write).with("y")
    serial.should_receive(:close)
    visit '/'
    click_button 'Feed'
    page.should have_content 'Fed!'
  end
end
