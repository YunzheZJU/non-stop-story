class CreateLives < ActiveRecord::Migration[6.0]
  def change
    create_table :lives do |t|
      t.string :title
      t.datetime :start_at
      t.integer :duration
      t.belongs_to :channel, foreign_key: true
      t.belongs_to :room, foreign_key: true
      t.belongs_to :video, foreign_key: true

      t.timestamps
    end
  end
end
