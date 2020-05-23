class AddUniqueConstraintToRooms < ActiveRecord::Migration[6.0]
  def change
    add_index :rooms, [:room, :platform_id], :unique => true
  end
end
