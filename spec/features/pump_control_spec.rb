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

  # Disable transactional fixtures for this example because
  # the dosing thread runs in a separate transaction.  And we're
  # not using fixtures anyway.
  self.use_transactional_fixtures = false
  it "doses" do
    Dose.destroy_all
    serial.should_receive(:write).with("y")
    visit '/'
    fill_in "Total quantity", :with => "1.0"
    fill_in "Number of cycles", :with => "2"
    fill_in "Pause between cycles", :with => "0.5"
    click_button 'Dose'
    page.should have_content 'Dosing...'
    dose = Dose.first
    dose.completed_at.should be_nil
    dose.total_quantity.should == 1.0
    dose.number_of_cycles.should == 2
    dose.pause_between_cycles.should == 0.5
    # After response is sent:
    serial.should_receive(:write).with("n").ordered
    serial.should_receive(:write).with("y").ordered
    serial.should_receive(:write).with("n").ordered
    sleep 1.5
    dose.reload.completed_at.to_f.should be_within(0.1).of(DateTime.now.to_f)
  end
end
