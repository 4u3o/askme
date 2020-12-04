class AddAuthorToQuestions < ActiveRecord::Migration[6.0]
  def change
    add_column :questions, :author_id, :integer
    add_foreign_key :questions, :users
  end
end
