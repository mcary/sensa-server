# Administer a dose
class Doser
  def initialize(klass, params, pump)
    @params = params
    @pump = pump
    @dose = save_dose(klass)
  end

  def run
    do_dosing
    record_completion
  end

  def self.cancel
    @@thread.kill
  end

  def start
    @@thread = Thread.new do
      run
    end
  end

  private

  attr_reader :params, :pump, :dose

  def save_dose(klass)
    klass.create!(sanitize_params)
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
