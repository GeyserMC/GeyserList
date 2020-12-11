class Server < ApplicationRecord
  belongs_to :user

  validates :name, :description, :java_ip, :bedrock_ip, presence: true
  validates :name, length: { in: 1..64 }
  validates :name, uniqueness: { message: "A server with that name already exists!" }
  validates :description, length: { in: 100..2500 }
  validates :bedrock_ip, :java_ip, presence: true, uniqueness: true
end
