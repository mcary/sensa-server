


class Pump
  attr_accessor :port, :baud

  def initialize(port, baud=9600, data_bits=8, stop_bits=1, parity=SerialPort::NONE)
    @port = port
    @baud = baud
    @data_bits = data_bits
    @stop_bits = stop_bits
    @parity = parity
    @serial = SerialPort.new(@port, @baud, @data_bits, @stop_bits, @parity)
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




class FeederController < ApplicationController
  def initialize
    @pump = Pump.new("/dev/tty.usbmodem641")
  end

  def index
    
  end

  def feed
    @pump.on
    redirect_to root_path, notice: "Fed!"
  end

  def starve
    @pump.off
    redirect_to root_path, notice: "Starved :("
  end

  def dose
    @pump.dose(5)
    redirect_to root_path, notice: "Dosed :)"
  end
end
