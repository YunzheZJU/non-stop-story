class CreateClips < ActiveRecord::Migration[6.0]
  def change
    create_table :clips do |t|
      t.integer :in_time
      t.integer :out_time
      t.belongs_to :live, foreign_key: true

      t.timestamps
    end
  end
end
