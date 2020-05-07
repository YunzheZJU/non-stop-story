class CreateArranges < ActiveRecord::Migration[6.0]
  def change
    create_table :arranges do |t|
      t.belongs_to :video, foreign_key: true

      t.timestamps
    end

    create_table :arranges_clips, id: false do |t|
      t.belongs_to :arrange
      t.belongs_to :clip
    end

    create_table :arranges_editors, id: false do |t|
      t.belongs_to :arrange
      t.belongs_to :editor
    end
  end
end
