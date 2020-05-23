class AddUniqueConstraintToChannels < ActiveRecord::Migration[6.0]
  def change
    add_index :channels, [:channel, :platform_id], :unique => true
  end
end
