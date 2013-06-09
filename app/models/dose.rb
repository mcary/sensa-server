class Dose < ActiveRecord::Base
  attr_accessible :completed_at, :cancelled_at, :number_of_cycles, :pause_between_cycles, :total_quantity, :worker
end
