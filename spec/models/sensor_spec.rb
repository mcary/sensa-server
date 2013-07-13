require 'spec_helper'

describe Sensor do
  let :valid_attributes do
    {
      name: "Disolved Oxygen",
      unit: "%",
    }
  end

  def attributes_without(key)
    valid_attributes.reject {|k,v| k == key }
  end

  it "creates" do
    Sensor.create! valid_attributes
  end

  it "requires name" do
    lambda {
      Sensor.create! attributes_without(:name)
    }.should raise_error(ActiveRecord::RecordInvalid)
  end

  it "requires unit" do
    lambda {
      Sensor.create! attributes_without(:unit)
    }.should raise_error(ActiveRecord::RecordInvalid)
  end

  it "enforces unique name with validation" do
    Sensor.create! valid_attributes
    lambda {
      Sensor.create! valid_attributes
    }.should raise_error(ActiveRecord::RecordInvalid)
  end

  it "enforces unique name with validation" do
    Sensor.create! valid_attributes
    sensor = Sensor.create! valid_attributes.merge(:name => "foo")
    lambda {
      # Bypass validations
      sensor.update_attribute(:name, valid_attributes[:name])
    }.should raise_error(ActiveRecord::RecordNotUnique)
  end
end
