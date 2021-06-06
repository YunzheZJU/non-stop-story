class CreateHotnesses < ActiveRecord::Migration[6.0]
  def change
    create_table :hotnesses do |t|
      t.belongs_to :live, foreign_key: true
      t.integer :watching
      t.integer :like

      t.timestamps
    end
    add_index :hotnesses, :created_at
    change_column_null :hotnesses, :live_id, false
  end
end
