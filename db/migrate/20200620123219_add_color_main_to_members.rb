class AddColorMainToMembers < ActiveRecord::Migration[6.0]
  def change
    add_column :members, :color_main, :string
  end
end
