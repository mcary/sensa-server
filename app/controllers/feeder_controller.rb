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
    @pump.dose(5)
    redirect_to root_path, notice: "Dosed :)"
  end
end
