class Dose < ActiveRecord::Base
  attr_accessible :finished_at, :status,
    :number_of_cycles, :pause_between_cycles, :total_quantity,
    :worker
end
