class HashtagsController < ApplicationController
  before_action :set_hashtag, only: [:show]

  def show
  end

  private

  def set_hashtag
    @hashtag = Hashtag.find_by(tag: params[:tag])
  end
end
