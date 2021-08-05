class Review < ApplicationRecord
  include ActionView::Helpers::DateHelper

  belongs_to :user
  belongs_to :server

  validates :rating, :user_id, :server_id, :presence => true
  validates :rating, :numericality => { only_integer: true, :greater_than_or_equal_to => 1, :less_than_or_equal_to => 5 }
  validates :description, :length => { in: 50..2000 }, :allow_blank => true

  # Gets the friendly formatting for this review timestamp.
  # "1m" "10m" etc
  # @return [String] The formatted time ago string
  def time_ago
    distance_of_time_in_words_to_now(created_at, include_seconds: true).gsub('about ', '').gsub(/ hours?/, 'h').gsub(/ seconds?/, 's').gsub(/ days?/, 'd').gsub(/ minutes?/, 'm').gsub(/ months?/, 'mo').gsub('half a', '1').gsub('less than a', '1')
  end

  # Checks to see if a user is able to delete this review
  # Currently, the review owner and moderators are the only ones who can.
  # @param user [User] The user to check
  # @return [Boolean] True if the user is able to delete, false otherwise
  def able_to_delete?(user)
    user.id == user_id || user.moderator?
  end
end