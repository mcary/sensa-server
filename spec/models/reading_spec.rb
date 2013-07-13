require 'spec_helper'

describe Reading do
  it "creates" do
    Reading.create!({
      value: 6.5,
      sensor: Sensor.create!(name: "DO", unit: "%"),
      measured_at: Time.now,
    })
  end
end
