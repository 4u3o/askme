class Question < ApplicationRecord
  belongs_to :user
  belongs_to :author, class_name: 'User', foreign_key: 'author_id', required: false

  validates :text, presence: true, length: { maximum: 255 }
end
