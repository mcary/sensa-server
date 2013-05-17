require 'spec_helper_no_rails'

# Without Rails, we don't have autoloading
require 'pump'
require 'singleton'

describe Pump do
  HardwareConfig = Struct.new(:serial_port)
  SerialPortConfig = Struct.new(:class_name, :path)
  class MockSerialPort
    class << self
      alias :orig_new :new
      attr_reader :instance
    end
    def self.new(*args)
      @instance ||= orig_new
    end
  end

  let(:config) do
    HardwareConfig.new(SerialPortConfig.new(:MockSerialPort, "foo"))
  end
  let(:serial) { MockSerialPort.instance }
  let(:pump) { Pump.new(config) }

  it "builds serial_port from config" do
    MockSerialPort.should_receive(:new).with("foo")
    Pump.new(config)
  end

  it "#on" do
    MockSerialPort.new
    serial.should_receive(:write).with("y")
    serial.should_receive(:close)
    pump.on
  end

  it "#off" do
    serial.should_receive(:write).with("n")
    serial.should_receive(:close)
    pump.off
  end

  it "#dose" do
    serial.should_receive(:write).with("y")
    serial.should_receive(:write).with("n")
    # We should probably be consistent about closing...
    #serial.should_receive(:close)
    pump.dose(0.1)
  end
end
