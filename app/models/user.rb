class User < ApplicationRecord
  has_many :servers
  has_many :integrations

  validates :username, :access_token, presence: true
  validates :username, uniqueness: { message: "An account with that name already exists!" }

  has_flags 1 => :moderator, # 1
            2 => :staff,     # 2
            3 => :verified,  # 4
            4 => :admin,     # 8
            5 => :developer, # 16
            :column => 'status'
end
