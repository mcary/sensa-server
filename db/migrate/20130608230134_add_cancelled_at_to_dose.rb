class AddCancelledAtToDose < ActiveRecord::Migration
  def change
    add_column :doses, :cancelled_at, :datetime
  end
end
