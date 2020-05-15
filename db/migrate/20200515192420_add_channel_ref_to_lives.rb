class AddChannelRefToLives < ActiveRecord::Migration[6.0]
  def change
    add_reference :lives, :channel, foreign_key: true
  end
end
