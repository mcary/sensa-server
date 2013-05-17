class Pump
  def initialize(serial_port=SimpleSerialPort.new("/dev/tty.usbmodem641"))
    @serial = serial_port
  end

  def on
    trigger_on
    @serial.close
  end

  def off
    trigger_off
    @serial.close
  end

  def dose(seconds)
    trigger_on
    sleep(seconds)
    trigger_off
  end

private

  def trigger_on
    @serial.write("y")
  end

  def trigger_off
    @serial.write("n")
  end
end
