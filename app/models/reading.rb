class Reading < ActiveRecord::Base
  attr_accessible :measured_at, :sensor, :value
  belongs_to :sensor
end
