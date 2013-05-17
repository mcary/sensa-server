# Development stub for SimpleSerialPort
#
# When running in development mode, I don't necessarily have a real
# Arduino to connect via serial port.  So mock something up that will
# pretend to be one and reveal what *would* have been sent over serial
# by logging it.
class DevSerialPort
  def initialize(path)
    self.logger = Rails.logger
  end

  def write(str)
    logger.info("#{self.class}##{__method__} #{str.inspect}")
  end

  def read
    raise NotImplementedError, "No dev stub for read yet"
  end

  def close
    logger.info("#{self.class}##{__method__}")
  end

  private

  attr_accessor :logger
end
