class Question < ApplicationRecord
  belongs_to :user
  belongs_to :author, class_name: 'User', foreign_key: 'author_id', optional: true
  has_and_belongs_to_many :hashtags

  validates :text, presence: true, length: { maximum: 255 }

  after_save_commit :hashtags_update

  private

  def hashtags_update
    self.hashtags =
      "#{text} #{answer}".downcase.scan(/#[\p{Word}-]+/i).uniq
                         .map { |tag| Hashtag.find_or_create_by(tag: tag) }
  end
end
