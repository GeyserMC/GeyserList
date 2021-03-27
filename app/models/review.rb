class Review < ApplicationRecord
  include ActionView::Helpers::DateHelper

  belongs_to :user
  belongs_to :server

  validates :rating, :user_id, :server_id, :presence => true
  validates :rating, :numericality => { only_integer: true, :greater_than_or_equal_to => 1, :less_than_or_equal_to => 5 }
  validates :review, :length => { in: 50..2000 }, :allow_blank => true

  def time_ago
    distance_of_time_in_words(created, Time.now, include_seconds: true).gsub('about ', '').gsub(/ hours?/, 'h').gsub(/ seconds?/, 's').gsub(/ days?/, 'd').gsub(/ minutes?/, 'm').gsub(/ months?/, 'mo').gsub('half a', '1').gsub('less than a', '1')
  end
end