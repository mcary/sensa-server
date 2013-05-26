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
    visit '/'
    fill_in "Total quantity", :with => "0.5"
    fill_in "Number of cycles", :with => "2"
    fill_in "Pause between cycles", :with => "0.5"
    click_button 'Dose'
    page.should have_content 'Dosing...'
    # After response is sent:
    serial.should_receive(:write).with("n").ordered
    serial.should_receive(:write).with("y").ordered
    serial.should_receive(:write).with("n").ordered
    sleep 1.5
  end
end
