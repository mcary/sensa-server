class CreateReadings < ActiveRecord::Migration
  def change
    create_table :readings do |t|
      t.decimal :value
      t.references :sensor
      t.datetime :measured_at
    end
  end
end
