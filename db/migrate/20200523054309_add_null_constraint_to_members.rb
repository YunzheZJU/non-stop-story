class AddNullConstraintToMembers < ActiveRecord::Migration[6.0]
  def change
    change_column_null :members, :name, false
  end
end
