require 'spec_helper'

describe Reading do
  let :valid_attributes do
    {
      value: 6.5,
      sensor: Sensor.create!(name: "DO", unit: "%"),
      measured_at: Time.now,
    }
  end

  def attributes_without(key)
    valid_attributes.reject {|k,v| k == key }
  end

  it "creates" do
    Reading.create! valid_attributes
  end

  it "requires value" do
    lambda {
      Reading.create! attributes_without(:value)
    }.should raise_error(ActiveRecord::RecordInvalid)
  end

  it "requires sensor" do
    lambda {
      Reading.create! attributes_without(:sensor)
    }.should raise_error(ActiveRecord::RecordInvalid)
  end

  it "requires measured_at" do
    lambda {
      Reading.create! attributes_without(:measured_at)
    }.should raise_error(ActiveRecord::RecordInvalid)
  end

  it "requires value is numeric" do
    lambda {
      Reading.create! valid_attributes.merge(:value => "x")
    }.should raise_error(ActiveRecord::RecordInvalid)
  end

  it "enforces unique name with validation" do
    Reading.create! valid_attributes
    lambda {
      Reading.create! valid_attributes
    }.should raise_error(ActiveRecord::RecordInvalid)
  end

  it "enforces unique name with validation" do
    Reading.create! valid_attributes
    later = valid_attributes[:measured_at] + 1
    sensor = Reading.create! valid_attributes.merge(:measured_at => later)
    lambda {
      # Bypass validations
      sensor.update_attribute(:measured_at, valid_attributes[:measured_at])
    }.should raise_error(ActiveRecord::RecordNotUnique)
  end
end
