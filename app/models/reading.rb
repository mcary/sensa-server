class Reading < ActiveRecord::Base
  attr_accessible :measured_at, :sensor, :value
  belongs_to :sensor
  validates :measured_at, :sensor, :value, presence: true
  validates :value, numericality: true
  validates :measured_at, uniqueness: { scope: :sensor_id }
end
