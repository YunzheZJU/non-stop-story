class AddNullConstraintToChannels < ActiveRecord::Migration[6.0]
  def change
    change_column_null :channels, :channel, false
    change_column_null :channels, :platform_id, false
  end
end
