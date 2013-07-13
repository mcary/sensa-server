require 'spec_helper'

describe Sensor do
  it "creates" do
    Sensor.create!(name: "Disolved Oxygen", unit: "%")
  end
end
