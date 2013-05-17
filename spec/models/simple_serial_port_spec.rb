require 'spec_helper'

describe SimpleSerialPort do
  subject do
    SerialPort.stub(:new => mock(:serial_port))
    SimpleSerialPort.new("/dev/non-existent-example")
  end

  # We're reaching into private implementation here, which is not
  # ideal.  But at least this violation should be restricted to
  # this spec; if the implementation changes, only this spec will
  # need to be fixed.
  let(:serial_port) { subject.send(:serial_port) }

  it "creates a new SerialPort" do
    SerialPort.should_receive(:new).with("/dev/non-existent-example",
                                         baud=9600, data_bits=8,
                                         stop_bits=1, parity=SerialPort::NONE)
    subject
  end

  it "#write delegates to its serial_port" do
    serial_port.should_receive(:write).with("y")
    subject.write("y")
  end

  it "#write does not leak a return value" do
    serial_port.stub(:write => :hi)
    subject.write("y").should == nil
  end

  it "#close delegates to its serial_port" do
    serial_port.should_receive(:close).with(no_args)
    subject.close
  end

  it "#close does not leak a return value" do
    serial_port.stub(:close => :hi)
    subject.close.should == nil
  end
end
