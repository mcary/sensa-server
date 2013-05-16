class Pump
  def initialize(hardware_config)
    serial_config = hardware_config.serial_port
    serial_class = Object.const_get(serial_config.class_name)
    @serial = serial_class.new(serial_config.path)
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
