# Simple wrapper for SerialPort
#
# The SerialPort interface is too broad; I want something narrower
# for which I can provide a good stub in development environments where
# the serial port is not connected to an Arduino.  See SimpleDevSerialPort.
class SimpleSerialPort
  def initialize(path)
    self.serial_port = SerialPort.new(path,
                                      baud=9600, data_bits=8,
                                      stop_bits=1, parity=SerialPort::NONE)
  end

  def write(str)
    serial_port.write(str)
    nil
  end

  def close
    serial_port.close
    nil
  end

  private

  attr_accessor :serial_port
end
