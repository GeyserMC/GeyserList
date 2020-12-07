class User < ApplicationRecord
  has_many :servers
  has_many :integrations

  validates :username, :access_token, presence: true
  validates :username, uniqueness: { message: "An account with that name already exists!" }
end
