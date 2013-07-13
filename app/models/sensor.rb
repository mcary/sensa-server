class Sensor < ActiveRecord::Base
  attr_accessible :name, :unit
  has_many :readings
end
