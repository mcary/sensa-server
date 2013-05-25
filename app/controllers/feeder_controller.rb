class FeederController < ApplicationController
  def initialize
    super
    @pump = Pump.new(Rails.configuration.hardware)
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
    pump = @pump # allow the thread block to capture the pump variable
    Thread.new do
      pump.dose(5)
    end
    redirect_to root_path, notice: "Dosing..."
  end
end
