class FeederController < ApplicationController
  def index
    @doses = Dose.order("id DESC")
  end

  def feed
    pump.on
    redirect_to index_url_opts, notice: "Fed!"
  end

  def starve
    pump.off
    redirect_to index_url_opts, notice: "Starved :("
  end

  def dose
    Doser.new(Dose, params, pump, logger).start
    redirect_to index_url_opts, notice: "Dosing..."
  end

  def cancel
    Doser.new(Dose, params, pump, logger).cancel
    redirect_to index_url_opts, notice: "Cancelled dose."
  end

  private

  def pump
    Pump.new(Rails.configuration.hardware)
  end

  def index_url_opts
    { action: :index }
  end
end
