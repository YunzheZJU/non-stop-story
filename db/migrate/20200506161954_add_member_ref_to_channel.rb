class AddMemberRefToChannel < ActiveRecord::Migration[6.0]
  def change
    add_reference :channels, :member, foreign_key: true
  end
end
