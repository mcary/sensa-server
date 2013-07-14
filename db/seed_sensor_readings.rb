# Generate some sensor readings to demonstrate graphing capability.
#
# This is not part of the main db/seeds.rb because a typical production
# installation will not use it.

Reading.delete_all
Sensor.delete_all

doxy = Sensor.find_or_create_by_name!(name: "Dissolved Oxygen", :unit => "%")
temp = Sensor.find_or_create_by_name!(name: "Temperature", :unit => "°F")

now = Time.now
start = now - 1.day
y_eq_on = 6.5 # equilibrium with pump on
y_eq_off = 1.5 # equilibrium with pump off
y = y_eq_on - 1
weight = 20

time = start
while time <= now
  x = time - start # seconds
  y_eq = case x
         when (8.hours..8.25.hours) then y_eq_off
         when (14.hours..14.03.hours) then y_eq_off
         else y_eq_on
         end
  time_of_day = time - start.to_date.to_time
  y_temp = 0.1 * -Math.sin(2 * Math::PI * (time_of_day / 1.day))
  y_eq += y_temp
  # Approach equilibrium for current state
  y = (y_eq + (weight * y)) / (weight+1)
  y_noise = rand() * 0.1
  doxy.readings.create!(value: y + y_noise, measured_at: time)
  time += 1.minute
end

time = start
while time <= now
  time_of_day = time - start.to_date.to_time
  y = 71 + 12.5 * -Math.sin(2 * Math::PI * (time_of_day / 1.day))
  y_noise = rand() * 0.3
  temp.readings.create!(value: y + y_noise, measured_at: time)
  time += 5.minute
end
