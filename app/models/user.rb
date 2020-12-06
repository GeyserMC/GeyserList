class User < ApplicationRecord
  has_many :servers
  has_many :integrations
end
