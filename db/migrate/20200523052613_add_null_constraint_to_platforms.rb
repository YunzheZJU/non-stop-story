class AddNullConstraintToPlatforms < ActiveRecord::Migration[6.0]
  def change
    change_column_null :platforms, :platform, false
  end
end
