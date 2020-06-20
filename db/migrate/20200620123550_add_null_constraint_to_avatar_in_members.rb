class AddNullConstraintToAvatarInMembers < ActiveRecord::Migration[6.0]
  def change
    change_column_null :members, :avatar, false
  end
end
