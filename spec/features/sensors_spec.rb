require 'spec_helper'

describe "Sensors", :type => :feature do
  let(:now) { Time.now }
  let(:sensor) { Sensor.create!(:name => "Dissolved Oxygen", :unit => "%") }

  before :each do
    3.times {|i| sensor.readings.create!(:value => i, :measured_at => now - i) }
  end

  describe "#show" do
    before :each do
      visit "/sensors/#{sensor.id}"
    end

    it "shows sensor title" do
      page.should have_content "Dissolved Oxygen (%)"
    end

    it "shows chart element" do
      page.should have_selector '#chart svg'
    end

    it "includes chart data" do
      page.source.should have_content \
        "[[#{(now.to_i-2) * 1000},2.0]" +
        ",[#{(now.to_i-1) * 1000},1.0]" +
        ",[#{(now.to_i-0) * 1000},0.0]]"
    end

    it "links to 'edit' page" do
      click_link "Edit"
      current_path.should == "/sensors/#{sensor.id}/edit"
    end

    it "links to 'show' page" do
      click_link "List"
      current_path.should == "/sensors"
    end

  end

  describe "#edit" do
    before :each do
      visit "/sensors/#{sensor.id}/edit"
    end

    it "does not show chart element" do
      page.should have_no_selector '#chart svg'
    end

    it "allows editing" do
      fill_in "Name", :with => "DO"
      fill_in "Unit", :with => "pct"
      click_button "Update Sensor"

      page.should have_content "Sensor was successfully updated"
      page.should have_content "DO (pct)"
    end

    it "links to 'show' page" do
      click_link "Show"
      current_path.should == "/sensors/#{sensor.id}"
    end

    it "links to 'list' page" do
      click_link "List"
      current_path.should == "/sensors"
    end

    it "allows destroying" do
      click_link "Destroy"
      current_path.should == "/sensors"
      page.should have_no_content "Dissolved Oxygen"
    end

    it "shows errors with invalid input" do
      fill_in "Name", :with => ""
      fill_in "Unit", :with => ""
      click_button "Update Sensor"

      page.should have_content "2 errors prohibited this sensor "+
                                 "from being saved"
      page.should have_content "Name can't be blank"
      page.should have_content "Unit can't be blank"
    end
  end

  describe "#new" do
    before :each do
      visit "/sensors/new"
    end

    it "allows creating a new sensor" do
      fill_in "Name", :with => "DO"
      fill_in "Unit", :with => "pct"
      click_button "Create Sensor"

      page.should have_content "Sensor was successfully created"
      page.should have_content "DO (pct)"
    end

    it "shows errors with invalid input" do
      click_button "Create Sensor"

      page.should have_content "2 errors prohibited this sensor "+
                                 "from being saved"
      page.should have_content "Name can't be blank"
      page.should have_content "Unit can't be blank"
    end

    it "new page does not show Show or Destroy buttons" do
      page.should have_no_link "Show"
      page.should have_no_link "Destroy"
    end
  end

  describe "#index" do
    before :each do
      visit "/sensors"
    end

    it "links to 'new' page" do
      click_link "New Sensor"
      current_path.should == "/sensors/new"
    end

    it "links to sensor page" do
      click_link "Dissolved Oxygen"
      current_path.should == "/sensors/#{sensor.id}"
    end

    it "shows current value" do
      page.should have_content "0.000 %"
    end

    it "shows trend" do
      page.should have_content "↓ 1.000"
    end
  end
end
