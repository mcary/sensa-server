class FeederController < ApplicationController
  def initialize
    super
    @pump = Pump.new(Rails.configuration.hardware)
  end

  def index
    @doses = Dose.all
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
    Doser.new(Dose, params, @pump).start
    redirect_to root_path, notice: "Dosing..."
  end

  def cancel
    @dose = Dose.find(params[:id])
    @dose.update_attributes!(cancelled_at: Time.now)
    Doser.cancel
    @pump.off
    redirect_to root_path, notice: "Cancelled dose."
    Rails.logger.info "Cancelled dose #{@dose.id}"
  end
end
