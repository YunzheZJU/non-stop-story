class AddCoverToLives < ActiveRecord::Migration[6.0]
  def change
    add_column :lives, :cover, :string
  end
end
