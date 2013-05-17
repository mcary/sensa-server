require 'spec_helper'

describe DevSerialPort do
  subject do
    DevSerialPort.new("/dev/non-existent-example")
  end

  let(:logger) { Rails.logger }

  it "#write logs" do
    logger.should_receive(:info).with('DevSerialPort#write "y"')
    subject.write("y")
  end

  it "#read raises" do
    lambda { subject.read }.should raise_error(NotImplementedError)
  end

  it "#close logs" do
    logger.should_receive(:info).with('DevSerialPort#close')
    subject.close
  end
end
