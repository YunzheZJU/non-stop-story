class AddColorSubToMembers < ActiveRecord::Migration[6.0]
  def change
    add_column :members, :color_sub, :string
  end
end
