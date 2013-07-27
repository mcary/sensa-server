require 'spec_helper'

describe "Site navigation", :type => :feature do
  context "on root path" do
    before :each do
      visit "/"
    end

    it "links site name to root path" do
      within ".navbar" do
        page.should have_selector ".brand:contains('Sensa BioBot')"
        click_link "Sensa BioBot"
        current_path.should == "/"
      end
    end

    it "highlights Sensors tab by default" do
      within ".navbar .active" do
        page.should have_content "Sensors"
      end
    end

    it "highlights exactly one tab" do
      page.should have_selector ".navbar .active", count: 1
    end

    it "lists sensors" do
      page.should have_content "Listing sensors"
    end
  end

  context "on /sensors" do
    before :each do
      visit "/sensors"
    end

    it "highlights Sensors tab" do
      within ".navbar .active" do
        page.should have_content "Sensors"
      end
    end

    it "highlights exactly one tab" do
      page.should have_selector ".navbar .active", count: 1
    end

    it "lists sensors" do
      page.should have_content "Listing sensors"
    end
  end

  context "on other sensor actions (/sensors/new)" do
    before :each do
      visit "/sensors/new"
    end

    it "highlights Sensors tab" do
      within ".navbar .active" do
        page.should have_content "Sensors"
      end
    end

    it "highlights exactly one tab" do
      page.should have_selector ".navbar .active", count: 1
    end
  end

  context "on /feeder" do
    before :each do
      visit "/feeder"
    end

    it "highlights Feeder tab" do
      within ".navbar .active" do
        page.should have_content "Feeder"
      end
    end

    it "highlights exactly one tab" do
      page.should have_selector ".navbar .active", count: 1
    end

    it "shows feeder" do
      page.should have_content "Feed Me"
    end
  end
end
