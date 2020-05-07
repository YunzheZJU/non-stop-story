class AddEditorRefToChannel < ActiveRecord::Migration[6.0]
  def change
    add_reference :channels, :editor, foreign_key: true
  end
end
