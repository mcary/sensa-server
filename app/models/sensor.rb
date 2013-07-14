class Sensor < ActiveRecord::Base
  attr_accessible :name, :unit
  has_many :readings
  validates :name, :unit, presence: true
end
