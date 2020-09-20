class AddGraduatedToMembers < ActiveRecord::Migration[6.0]
  def change
    add_column :members, :graduated, :boolean, default: false
  end
end
