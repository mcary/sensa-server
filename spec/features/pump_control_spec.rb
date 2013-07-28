require 'spec_helper'

describe "Feeding", :type => :feature do
  let(:serial) { mock(:serial) }
  before :each do
    SimpleSerialPort.stub(:new => serial)
  end

  it "feeds" do
    serial.should_receive(:write).with("y")
    serial.should_receive(:close)
    visit '/feeder'
    click_button 'Feed'
    page.should have_content 'Fed!'
  end

  it "starves" do
    serial.should_receive(:write).with("n")
    serial.should_receive(:close)
    visit '/feeder'
    click_button 'Starve'
    page.should have_content 'Starved :('
  end

  describe "Dosing" do
    # Disable transactional fixtures for this example because
    # the dosing thread runs in a separate transaction.  And we're
    # not using fixtures anyway.
    self.use_transactional_fixtures = false
    before :each do
      Dose.destroy_all
    end

    it "doses" do
      serial.should_receive(:write).with("y")
      visit '/feeder'
      fill_in "Total quantity", :with => "1.0"
      fill_in "Number of cycles", :with => "2"
      fill_in "Pause between cycles", :with => "0.5"
      click_button 'Dose'
      page.should have_content 'Dosing...'
      dose = Dose.first
      dose.finished_at.should be_nil
      dose.status.should be_nil
      dose.total_quantity.should == 1.0
      dose.number_of_cycles.should == 2
      dose.pause_between_cycles.should == 0.5
      # After response is sent:
      serial.should_receive(:write).with("n").ordered
      serial.should_receive(:write).with("y").ordered
      serial.should_receive(:write).with("n").ordered
      sleep 1.5
      finish_time = DateTime.now
      sleep 0.3
      dose.reload
      dose.finished_at.to_f.should be_within(0.3).of(finish_time.to_f)
      dose.status.should == "completed"
    end

    it "shows past doses" do
      Dose.create!(:total_quantity => 4.2,
                   :number_of_cycles => 3,
                   :pause_between_cycles => 40,
                   :status => :completed,
                   # Time.parse seems to assume UTC, which may be incorrect
                   :finished_at => Time.zone.parse('2013-01-01 08:00'))
      visit '/feeder'
      page.should have_content 'Total quantity'
      page.should have_content '4.2'
      page.should have_content '3'
      page.should have_content '40'
      page.should have_content 'Completed'
      page.should have_content '2013-01-01 08:00'
      page.should have_no_content '#<Dose' # Fixed but in template
    end

    it "cancels in-progress doses" do
      serial.should_receive(:write).with("y").ordered
      serial.should_receive(:write).with("n").ordered
      serial.stub(:close) # Not sure we should expect this

      visit '/feeder'
      fill_in "Total quantity", :with => "0.5"
      fill_in "Number of cycles", :with => "1"
      fill_in "Pause between cycles", :with => "0"
      click_button 'Dose'

      click_link "cancel"

      dose = Dose.first
      dose.finished_at.to_f.should be_within(0.1).of(DateTime.now.to_f)
      dose.status.should == "cancelled"
      page.should have_content("Cancelled dose") # Flash
      page.should have_no_link("cancel")
      page.should have_content(dose.finished_at)

      # Note, expectations violated in another thread will not show up here
      #serial.should_not_receive(:write)

      # Wait to make sure background task doesn't turn off again
      sleep(0.75)
      dose.reload.status.should == "cancelled" # not "completed"
    end

    it "records exceptions as failures" do
      # Force failure by mocking the dose for this one
      # Normally feature specs will avoid mocking, but this error
      # condition is hard to replicate otherwise.
      Pump.any_instance.stub(:dose).and_raise Exception.new("Test Error!")
      visit '/feeder'
      fill_in "Total quantity", :with => "1.0"
      fill_in "Number of cycles", :with => "2"
      fill_in "Pause between cycles", :with => "0.5"
      click_button 'Dose'
      page.should have_content 'Dosing...'
      failure_time = DateTime.now
      sleep 0.1
      dose = Dose.first
      dose.finished_at.to_f.should be_within(0.2).of(failure_time.to_f)
      dose.status.should == 'failed'
      dose.total_quantity.should == 1.0
      dose.number_of_cycles.should == 2
      dose.pause_between_cycles.should == 0.5
    end
  end
end
