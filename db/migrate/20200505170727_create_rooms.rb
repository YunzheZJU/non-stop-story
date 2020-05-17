class CreateRooms < ActiveRecord::Migration[6.0]
  def change
    create_table :rooms do |t|
      t.string :room
      t.belongs_to :platform, foreign_key: true

      t.timestamps
    end
    add_index :rooms, :room
  end
end
