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
    quantity = params[:total_quantity].to_f
    cycles = params[:number_of_cycles].to_i
    pause = params[:pause_between_cycles].to_f
    Thread.new do
      cycles.times do
        pump.dose(quantity / cycles)
        sleep(pause)
      end
    end
    redirect_to root_path, notice: "Dosing..."
  end
end
