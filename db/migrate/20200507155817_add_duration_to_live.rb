class AddDurationToLive < ActiveRecord::Migration[6.0]
  def change
    add_column :lives, :duration, :integer
  end
end
