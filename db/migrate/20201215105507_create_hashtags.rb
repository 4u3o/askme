class CreateHashtags < ActiveRecord::Migration[6.0]
  def change
    create_table :hashtags do |t|
      t.string :tag, null: false, limit: 20
      t.index :tag, unique: true
      t.timestamps
    end

    create_join_table :questions, :hashtags do |t|
      t.index :question_id
      t.index :hashtag_id
    end
  end
end
