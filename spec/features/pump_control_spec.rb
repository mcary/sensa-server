require 'spec_helper'

describe "FeederController", :type => :feature do
  let(:serial) { mock(:serial) }
  before :each do
    SimpleSerialPort.stub(:new => serial)
  end

  it "feeds" do
    serial.should_receive(:write).with("y")
    serial.should_receive(:close)
    visit '/'
    click_button 'Feed'
    page.should have_content 'Fed!'
  end

  it "starves" do
    serial.should_receive(:write).with("n")
    serial.should_receive(:close)
    visit '/'
    click_button 'Starve'
    page.should have_content 'Starved :('
  end

  it "doses" do
    serial.should_receive(:write).with("y")
    serial.should_receive(:write).with("n")
    # We should probably be consistent about closing...
    #serial.should_receive(:close)
    visit '/'
    click_button 'Dose'
    page.should have_content 'Dosed :)'
  end
end
