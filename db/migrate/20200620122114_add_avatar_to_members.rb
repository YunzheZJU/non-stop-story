class AddAvatarToMembers < ActiveRecord::Migration[6.0]
  def change
    add_column :members, :avatar, :string, default: ''
  end
end
