class AddVideoRefToLive < ActiveRecord::Migration[6.0]
  def change
    add_reference :lives, :video, foreign_key: true
  end
end
