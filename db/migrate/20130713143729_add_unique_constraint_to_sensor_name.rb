class AddUniqueConstraintToSensorName < ActiveRecord::Migration
  def change
    change_table :sensors do |t|
      t.index :name, unique: true
    end
  end
end
