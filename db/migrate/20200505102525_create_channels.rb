class CreateChannels < ActiveRecord::Migration[6.0]
  def change
    create_table :channels do |t|
      t.string :channel
      t.belongs_to :platform, foreign_key: true

      t.timestamps
    end
  end
end
