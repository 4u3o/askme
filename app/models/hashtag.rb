class Hashtag < ApplicationRecord
  has_and_belongs_to_many :questions

  scope :with_questions,
        -> { joins(:questions).distinct }

  validates :tag, uniqueness: true, presence: true, length: { maximum: 20 }
end
