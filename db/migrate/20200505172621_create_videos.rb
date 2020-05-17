class CreateVideos < ActiveRecord::Migration[6.0]
  def change
    create_table :videos do |t|
      t.string :video
      t.string :title
      t.integer :duration
      t.belongs_to :platform, foreign_key: true

      t.timestamps
    end
    add_index :videos, :video
    add_index :videos, :title
    add_index :videos, :duration
  end
end
