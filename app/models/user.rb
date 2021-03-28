class User < ApplicationRecord
  has_many :servers
  has_many :integrations
  has_many :reviews

  validates :username, :access_token, presence: true
  validates :username, uniqueness: { message: "An account with that name already exists!" }
  
  include FlagShihTzu

  has_flags 1 => :moderator, # 1
            2 => :verified,  # 2
            3 => :developer, # 4
            :column => 'status'

  def reviewed?(server)
    !Review.find_by(server_id: server.id, user_id: id).nil?
  end

  def verified_icon
    return unless verified?

    ActionController::Base.helpers.image_tag "verified.png", style: 'margin-top: -5px'
  end
end
