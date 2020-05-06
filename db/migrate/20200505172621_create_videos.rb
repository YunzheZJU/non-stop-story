class CreateVideos < ActiveRecord::Migration[6.0]
  def change
    create_table :videos do |t|
      t.string :video
      t.integer :duration
      t.belongs_to :platform, foreign_key: true

      t.timestamps
    end
  end
end
