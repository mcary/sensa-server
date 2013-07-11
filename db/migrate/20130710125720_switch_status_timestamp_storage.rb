class SwitchStatusTimestampStorage < ActiveRecord::Migration
  def change
    add_column :doses, :status, :string
    add_column :doses, :finished_at, :datetime
    # Not gonna bother migrating the data since we don't have much to preserve.
    remove_column :doses, :completed_at
    remove_column :doses, :cancelled_at
  end
end
