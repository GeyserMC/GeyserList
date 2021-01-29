class User < ApplicationRecord
  has_many :servers
  has_many :integrations
  has_many :reviews

  validates :username, :access_token, presence: true
  validates :username, uniqueness: { message: "An account with that name already exists!" }

  def reviewed?(server)
    !Review.find_by(server_id: server.id, user_id: id).nil?
  end
end
