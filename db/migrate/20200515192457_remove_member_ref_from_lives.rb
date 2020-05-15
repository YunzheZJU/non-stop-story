class RemoveMemberRefFromLives < ActiveRecord::Migration[6.0]
  def change
    remove_reference :lives, :member, foreign_key: true
  end
end
