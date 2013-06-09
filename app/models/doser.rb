# Administer a dose
class Doser
  def initialize(klass, params, pump)
    @params = params
    @pump = pump
    @dose_class = klass
  end

  def run
    save_dose
    do_dosing
  end

  def cancel
    @dose = @dose_class.find(params[:id].to_s)
    dose.update_attributes!(cancelled_at: Time.now)
    @@thread.kill
    pump.off
  end

  def start
    save_dose
    @@thread = Thread.new do
      do_dosing
    end
  end

  private

  attr_reader :params, :pump, :dose

  def save_dose
    @dose = @dose_class.create!(sanitize_params)
  end

  def sanitize_params
    pairs = param_types.map do |key, meth|
      [key, params[key].send(meth)]
    end
    Hash[pairs]
  end

  def param_types
    {
      total_quantity: :to_f,
      number_of_cycles: :to_i,
      pause_between_cycles: :to_f,
    }
  end

  def do_dosing
    do_cycles
    record_completion
  end

  def do_cycles
    quantity = dose.total_quantity
    cycles = dose.number_of_cycles
    pause = dose.pause_between_cycles

    cycles.times do |i|
      pump.dose(quantity / cycles)
      sleep(pause) if i < cycles - 1 # skip last sleep
    end
  end

  def record_completion
    dose.completed_at = Time.now
    dose.save!
  end
end
