class Question < ApplicationRecord
  belongs_to :user
  belongs_to :author, class_name: 'User', foreign_key: 'author_id', optional: true
  has_and_belongs_to_many :hashtags # dependent: :destroy

  validates :text, presence: true, length: { maximum: 255 }

  after_save :find_tags, :hashtags_update, :refresh_tags

  def find_tags
    question_text = [text, answer].join(' ')
    @tags_after_update = question_text.scan(/#[\p{Word}-]+/i).uniq
    @tags_after_update.map!(&:downcase)
  end

  def hashtags_update
    tags_before_update = hashtags.pluck(:tag)

    outdated_tags = hashtags.where(tag: tags_before_update - @tags_after_update)

    hashtags.delete(outdated_tags)

    new_tags = @tags_after_update - tags_before_update

    if new_tags
      new_tags.each do |tag|
        hashtags << Hashtag.find_or_create_by(tag: tag)
      end
    end
  end

  def refresh_tags
    Hashtag.left_joins(:questions).where(questions: { id: nil }).destroy_all
  end
end
