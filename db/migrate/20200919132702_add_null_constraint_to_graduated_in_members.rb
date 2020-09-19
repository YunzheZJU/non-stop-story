class AddNullConstraintToGraduatedInMembers < ActiveRecord::Migration[6.0]
  def change
    change_column_null :members, :graduated, false
  end
end
