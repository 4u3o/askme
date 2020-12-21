class Question < ApplicationRecord
  belongs_to :user
  belongs_to :author, class_name: 'User', foreign_key: 'author_id', optional: true
  has_and_belongs_to_many :hashtags

  validates :text, presence: true, length: { maximum: 255 }

  after_save :hashtags_update, :hashtags_destroy
  after_destroy :hashtags_destroy

  private

  def hashtags_update
    @tags_after_update =
      [text, answer].join(' ')
                    .scan(/#[\p{Word}-]+/i).uniq.map(&:downcase)


    tags_before_update = hashtags.pluck(:tag)

    unless @tags_after_update == tags_before_update
      outdated_tags = hashtags.where(tag: tags_before_update - @tags_after_update)

      hashtags.delete(outdated_tags) unless outdated_tags.empty?
    end

    unless @tags_after_update.empty?
      new_tags = @tags_after_update - tags_before_update

      if new_tags
        new_tags.each do |tag|
          hashtags << Hashtag.find_or_create_by(tag: tag)
        end
      end
    end
  end

  def hashtags_destroy
    Hashtag.left_joins(:questions).where(questions: { id: nil }).destroy_all
  end
end
