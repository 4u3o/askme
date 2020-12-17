class HashtagsController < ApplicationController
  before_action :set_hashtag, only: [:show]

  def show
  end

  private

  def set_hashtag
    @hashtag = Hashtag.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def hashtag_params
    params.fetch(:hashtag, {})
  end
end
