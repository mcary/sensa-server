class AddUniqueConstraintToReadingSensorAndTime < ActiveRecord::Migration
  def change
    change_table :readings do |t|
      t.index [:sensor_id, :measured_at], unique: true
    end
  end
end
