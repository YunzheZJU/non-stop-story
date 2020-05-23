class AddNullConstraintToRooms < ActiveRecord::Migration[6.0]
  def change
    change_column_null :rooms, :room, false
    change_column_null :rooms, :platform_id, false
  end
end
