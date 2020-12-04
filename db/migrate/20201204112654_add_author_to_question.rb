class AddAuthorToQuestion < ActiveRecord::Migration[6.0]
  change_table :questions do |t|
    t.belongs_to :author, foreign_key: { to_table: :users }
  end
end
