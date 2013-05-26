class CreateDoses < ActiveRecord::Migration
  def change
    create_table :doses do |t|
      t.decimal :total_quantity
      t.integer :number_of_cycles
      t.decimal :pause_between_cycles
      t.string :worker
      t.datetime :completed_at

      t.timestamps
    end
  end
end
