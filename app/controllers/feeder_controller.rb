class FeederController < ApplicationController
  def index
    @doses = Dose.order("id DESC")
  end

  def feed
    pump.on
    redirect_to root_path, notice: "Fed!"
  end

  def starve
    pump.off
    redirect_to root_path, notice: "Starved :("
  end

  def dose
    Doser.new(Dose, params, pump, logger).start
    redirect_to root_path, notice: "Dosing..."
  end

  def cancel
    Doser.new(Dose, params, pump, logger).cancel
    redirect_to root_path, notice: "Cancelled dose."
  end

  private

  def pump
    Pump.new(Rails.configuration.hardware)
  end
end
