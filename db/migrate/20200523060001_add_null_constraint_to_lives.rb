class AddNullConstraintToLives < ActiveRecord::Migration[6.0]
  def change
    change_column_null :lives, :title, false
    change_column_null :lives, :start_at, false
    change_column_null :lives, :channel_id, false
    change_column_null :lives, :room_id, false
  end
end
