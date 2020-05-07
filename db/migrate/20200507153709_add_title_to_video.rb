class AddTitleToVideo < ActiveRecord::Migration[6.0]
  def change
    add_column :videos, :title, :string
  end
end
